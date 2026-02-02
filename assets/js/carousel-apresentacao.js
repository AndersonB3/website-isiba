/* ========================================
   CARROSSEL DE APRESENTAÇÃO INSTITUCIONAL
   ======================================== */

document.addEventListener('DOMContentLoaded', () => {
    // IDs dos slides do Google Slides (extraídos da URL da apresentação)
    const presentationId = '2PACX-1vS0veJvW1owHuxF2AuhOW-T084ajrd33n1Q1nIU-mza3P6tXjxM1qkB8i9FCOUo5tvAoGybg066D8Ue';
    
    // URLs das imagens dos slides (exportadas do Google Slides)
    const slides = [
        `https://docs.google.com/presentation/d/${presentationId}/export/png?id=${presentationId}&pageid=p`,
        `https://docs.google.com/presentation/d/${presentationId}/export/png?id=${presentationId}&pageid=p1`,
        `https://docs.google.com/presentation/d/${presentationId}/export/png?id=${presentationId}&pageid=p2`,
        `https://docs.google.com/presentation/d/${presentationId}/export/png?id=${presentationId}&pageid=p3`,
        `https://docs.google.com/presentation/d/${presentationId}/export/png?id=${presentationId}&pageid=p4`,
        `https://docs.google.com/presentation/d/${presentationId}/export/png?id=${presentationId}&pageid=p5`
    ];

    let currentSlide = 0;
    const slidesContainer = document.getElementById('carouselSlides');
    const indicatorsContainer = document.getElementById('carouselIndicators');
    const slideCounter = document.getElementById('slideCounter');
    const prevBtn = document.getElementById('prevSlide');
    const nextBtn = document.getElementById('nextSlide');

    // Verificar se os elementos existem
    if (!slidesContainer || !indicatorsContainer) {
        console.warn('Elementos do carrossel não encontrados');
        return;
    }

    // Criar slides
    function createSlides() {
        slidesContainer.innerHTML = '';
        
        slides.forEach((slideUrl, index) => {
            const slideDiv = document.createElement('div');
            slideDiv.className = `carousel__slide ${index === 0 ? 'active' : ''}`;
            
            const img = document.createElement('img');
            img.src = slideUrl;
            img.alt = `Slide ${index + 1} da Apresentação Institucional`;
            img.loading = 'lazy';
            
            // Fallback caso a imagem não carregue
            img.onerror = () => {
                img.src = `https://via.placeholder.com/1200x675/0066cc/ffffff?text=Slide+${index + 1}`;
            };
            
            slideDiv.appendChild(img);
            slidesContainer.appendChild(slideDiv);
        });
    }

    // Criar indicadores
    function createIndicators() {
        indicatorsContainer.innerHTML = '';
        
        slides.forEach((_, index) => {
            const indicator = document.createElement('button');
            indicator.className = `carousel__indicator ${index === 0 ? 'active' : ''}`;
            indicator.setAttribute('aria-label', `Ir para slide ${index + 1}`);
            indicator.addEventListener('click', () => goToSlide(index));
            indicatorsContainer.appendChild(indicator);
        });
    }

    // Atualizar contador
    function updateCounter() {
        if (slideCounter) {
            slideCounter.textContent = `${currentSlide + 1} / ${slides.length}`;
        }
    }

    // Ir para slide específico
    function goToSlide(index) {
        const allSlides = slidesContainer.querySelectorAll('.carousel__slide');
        const allIndicators = indicatorsContainer.querySelectorAll('.carousel__indicator');
        
        // Remover classe active de todos
        allSlides.forEach(slide => slide.classList.remove('active'));
        allIndicators.forEach(indicator => indicator.classList.remove('active'));
        
        // Adicionar classe active ao slide atual
        currentSlide = index;
        allSlides[currentSlide].classList.add('active');
        allIndicators[currentSlide].classList.add('active');
        
        updateCounter();
    }

    // Próximo slide
    function nextSlide() {
        const nextIndex = (currentSlide + 1) % slides.length;
        goToSlide(nextIndex);
    }

    // Slide anterior
    function prevSlide() {
        const prevIndex = (currentSlide - 1 + slides.length) % slides.length;
        goToSlide(prevIndex);
    }

    // Event listeners
    if (prevBtn) prevBtn.addEventListener('click', prevSlide);
    if (nextBtn) nextBtn.addEventListener('click', nextSlide);

    // Navegação por teclado
    document.addEventListener('keydown', (e) => {
        if (e.key === 'ArrowLeft') prevSlide();
        if (e.key === 'ArrowRight') nextSlide();
    });

    // Touch/swipe para mobile
    let touchStartX = 0;
    let touchEndX = 0;

    slidesContainer.addEventListener('touchstart', (e) => {
        touchStartX = e.changedTouches[0].screenX;
    });

    slidesContainer.addEventListener('touchend', (e) => {
        touchEndX = e.changedTouches[0].screenX;
        handleSwipe();
    });

    function handleSwipe() {
        const swipeThreshold = 50;
        const diff = touchStartX - touchEndX;
        
        if (Math.abs(diff) > swipeThreshold) {
            if (diff > 0) {
                nextSlide();
            } else {
                prevSlide();
            }
        }
    }

    // Autoplay (opcional - descomente se quiser)
    /*
    let autoplayInterval;
    
    function startAutoplay() {
        autoplayInterval = setInterval(nextSlide, 5000);
    }
    
    function stopAutoplay() {
        clearInterval(autoplayInterval);
    }
    
    // Pausar autoplay ao hover
    slidesContainer.addEventListener('mouseenter', stopAutoplay);
    slidesContainer.addEventListener('mouseleave', startAutoplay);
    
    // Iniciar autoplay
    startAutoplay();
    */

    // Inicializar
    createSlides();
    createIndicators();
    updateCounter();
    
    console.log('✅ Carrossel de apresentação inicializado!');
});
