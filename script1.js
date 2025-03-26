document.addEventListener("DOMContentLoaded", function() {

    // Funzione per mostrare una slide specifica in base all'indice
    function showSlide(slides, index) {
      slides.forEach(function(slide, idx) {
        slide.classList.toggle('active', idx === index);
      });
    }
  
    // Funzione per creare (o aggiornare) l'overlay evidenziato sulla zona cliccata,
    // adattando le coordinate in base alle dimensioni renderizzate dell'immagine.
    function highlightArea(area, fascicolo) {
      // Se fascicolo non è passato, lo cerchiamo nel contesto dell'area
      fascicolo = fascicolo || area.closest('.fascicolo');
      if (fascicolo) {
        // Rimuove eventuali overlay esistenti nel fascicolo corrente
        fascicolo.querySelectorAll('.highlight-overlay').forEach(function(overlay) {
          overlay.parentNode.removeChild(overlay);
        });
      }
      
      // Recupera le coordinate originali dall'attributo "coords"
      const coords = area.getAttribute('coords').split(',').map(Number);
      if (coords.length < 4) return;
      
      // Ottieni il <map> di cui fa parte l'area
      const mapName = area.parentElement.getAttribute('name');
      // Cerca l'immagine all'interno del fascicolo corrente
      const img = fascicolo ? fascicolo.querySelector('img[usemap="#' + mapName + '"]') : null;
      
      if (img) {
        // Dimensioni originali (come definite negli attributi width/height)
        const originalWidth = parseFloat(img.getAttribute('width'));
        const originalHeight = parseFloat(img.getAttribute('height'));
        // Dimensioni attuali renderizzate
        const renderedWidth = img.offsetWidth;
        const renderedHeight = img.offsetHeight;
        
        // Fattori di scala
        const scaleX = renderedWidth / originalWidth;
        const scaleY = renderedHeight / originalHeight;
        
        // Calcola posizione e dimensioni scalate (assumendo coords = [x1, y1, x2, y2])
        const x = coords[0] * scaleX;
        const y = coords[1] * scaleY;
        const width = (coords[2] - coords[0]) * scaleX;
        const height = (coords[3] - coords[1]) * scaleY;
        
        // Trova la slide che contiene l'immagine
        const slide = img.closest('.slide');
        if (slide) {
          // Assicurati che la slide abbia posizione relativa
          slide.style.position = 'relative';
          // Crea l'overlay evidenziato
          const overlay = document.createElement('div');
          overlay.className = 'highlight-overlay';
          overlay.style.position = 'absolute';
          overlay.style.left = x + 'px';
          overlay.style.top = y + 'px';
          overlay.style.width = width + 'px';
          overlay.style.height = height + 'px';
          overlay.style.border = '2px solid red';
          overlay.style.backgroundColor = 'rgba(255, 0, 0, 0.2)';
          overlay.style.pointerEvents = 'none'; // Permette il click sull'immagine sottostante
          slide.appendChild(overlay);
        }
      }
    }
  
    // Funzione che, dato un'immagine e le coordinate del click, verifica se il punto cade in una zona
    function handleImageClick(img, clickX, clickY, fascicolo) {
      const usemap = img.getAttribute('usemap');
      if (!usemap) return;
      const mapName = usemap.substring(1); // Rimuove il #
      // Seleziona tutte le aree della mappa all'interno del fascicolo corrente
      const areas = fascicolo ? fascicolo.querySelectorAll('map[name="' + mapName + '"] area') : [];
      let foundArea = null;
      
      // Ottieni i fattori di scala per l'immagine
      const originalWidth = parseFloat(img.getAttribute('width'));
      const originalHeight = parseFloat(img.getAttribute('height'));
      const renderedWidth = img.offsetWidth;
      const renderedHeight = img.offsetHeight;
      const scaleX = renderedWidth / originalWidth;
      const scaleY = renderedHeight / originalHeight;
      
      areas.forEach(function(area) {
        const coords = area.getAttribute('coords').split(',').map(Number);
        if (coords.length >= 4) {
          // Calcola le coordinate scalate per l'area
          const x = coords[0] * scaleX;
          const y = coords[1] * scaleY;
          const x2 = coords[2] * scaleX;
          const y2 = coords[3] * scaleY;
          // Se il click cade all'interno della zona, allora la seleziona
          if (clickX >= x && clickX <= x2 &&
              clickY >= y && clickY <= y2) {
            foundArea = area;
          }
        }
      });
      if (foundArea) {
        foundArea.dispatchEvent(new MouseEvent('click', {cancelable: true, bubbles: true}));
      }
    }
  
    // Gestione per ogni fascicolo, per isolare le logiche 
    document.querySelectorAll('.fascicolo').forEach(function(fascicolo) {
      let currentSlideIndex = 0;
      const imageSlides = fascicolo.querySelectorAll('.left-column .slide');
      const textSlides = fascicolo.querySelectorAll('.text-slides .text-slide');
      const navigation = fascicolo.querySelector('.navigation');
  
      // Inizializza gli slider: mostra la prima slide per immagini e testo
      if (imageSlides.length > 0) {
        showSlide(imageSlides, currentSlideIndex);
      }
      if (textSlides.length > 0) {
        showSlide(textSlides, currentSlideIndex);
      }
  
      // Funzione per aggiornare entrambi gli slider e rimuovere overlay nel fascicolo corrente
      function updateSlides(index) {
        showSlide(imageSlides, index);
        showSlide(textSlides, index);
        fascicolo.querySelectorAll('.highlight-overlay').forEach(function(overlay) {
          overlay.parentNode.removeChild(overlay);
        });
      }
  
      // Gestione del click sulle aree mappate all'interno del fascicolo
      fascicolo.querySelectorAll('area').forEach(function(area) {
        area.addEventListener('click', function(e) {
          e.preventDefault();
          const ref = this.getAttribute('data-ref');
          // Evidenzia la zona cliccata
          highlightArea(this, fascicolo);
          // Nasconde tutte le text-slide del fascicolo e mostra quella corrispondente
          textSlides.forEach(function(slide) {
            slide.classList.remove('active');
          });
          const targetSlide = fascicolo.querySelector('.text-slide[data-ref="' + ref + '"]');
          if (targetSlide) {
            targetSlide.classList.add('active');
          }
        });
      });
  
      // Aggiungi un listener su ogni immagine per catturare il click in ogni punto
      fascicolo.querySelectorAll('.left-column img').forEach(function(img) {
        img.addEventListener('click', function(e) {
          // Calcola la posizione del click relativa all'immagine
          const rect = img.getBoundingClientRect();
          const clickX = e.clientX - rect.left;
          const clickY = e.clientY - rect.top;
          // Verifica se il click cade in una zona della mappa relativa all'immagine
          handleImageClick(img, clickX, clickY, fascicolo);
        });
      });
  
      // Gestione dei pulsanti di navigazione all'interno del fascicolo
      if (navigation) {
        const prevButton = navigation.querySelector('.prev');
        const nextButton = navigation.querySelector('.next');
  
        if (prevButton) {
          prevButton.addEventListener('click', function(e) {
            e.preventDefault();
            currentSlideIndex = (currentSlideIndex - 1 + imageSlides.length) % imageSlides.length;
            updateSlides(currentSlideIndex);
          });
        }
  
        if (nextButton) {

          nextButton.addEventListener('click', function(e) {
            e.preventDefault();
            currentSlideIndex = (currentSlideIndex + 1) % imageSlides.length;
            updateSlides(currentSlideIndex);
          });
        }
      }

      // Seleziona tutti i pulsanti .button (in entrambi i fascicoli)
      const buttons = document.querySelectorAll('.button');
      
      buttons.forEach(button => {
        button.addEventListener('click', () => {

          // Rimuovo la classe attiva da tutti i pulsanti
          buttons.forEach(btn => btn.classList.remove('active-button'));

          // Aggiungo la classe al pulsante cliccato
          button.classList.add('active-button');

          // 'cat' sarà la categoria
          const cat = button.id;

          // 1) Trovo il fascicolo di appartenenza di quel pulsante
          //    (cioè l'antenato con classe .fascicolo)
          const fascicoloContainer = button.closest('.fascicolo');
          if (!fascicoloContainer) {
            console.warn('Non ho trovato il contenitore .fascicolo per questo pulsante');
            return;
          }

          // 2) Rimuovo highlight solo negli elementi di questo fascicolo
          //    (non tocco l'altro fascicolo)
          const allMarkedInThisFascicolo = fascicoloContainer.querySelectorAll('.testo-categorizzato');
          allMarkedInThisFascicolo.forEach(el => el.classList.remove('highlight'));

          // 3) Evidenzio solo quelli con data-cat corrispondente, sempre *in questo fascicolo*
          const toHighlight = fascicoloContainer.querySelectorAll(`.testo-categorizzato[data-cat="${cat}"]`);
          toHighlight.forEach(el => el.classList.add('highlight'));

        });
      });
    });
});
  