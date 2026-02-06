/* ========================================
   CARROSSEL DE APRESENTAÇÃO INSTITUCIONAL
   Loop automático com imagens locais
   + PRÉ-CARREGAMENTO para GitHub Pages
   ======================================== */

document.addEventListener('DOMContentLoaded', () => {
    // Caminho base das imagens
    const basePath = 'assets/img/apresentacao/';
    
    // Array de imagens dos slides (18 slides)
    const slides = [
        `${basePath}slide-1.png`,
        `${basePath}slide-2.png`,
        `${basePath}slide-3.png`,
        `${basePath}slide-4.png`,
        `${basePath}slide-5.png`,
        `${basePath}slide-6.png`,
        `${basePath}slide-7.png`,
        `${basePath}slide-8.png`,
        `${basePath}slide-9.png`,
        `${basePath}slide-10.png`,
        `${basePath}slide-11.png`,
        `${basePath}slide-12.png`,
        `${basePath}slide-13.png`,
        `${basePath}slide-14.png`,
        `${basePath}slide-15.png`,
        `${basePath}slide-16.png`,
        `${basePath}slide-17.png`,
        `${basePath}slide-18.png`
    ];

    let currentSlide = 0;
    let autoplayInterval;
    let imagesPreloaded = false;
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

    // ========================================
    // PRÉ-CARREGAR TODAS AS IMAGENS
    // ========================================
    function preloadImages() {
        return new Promise((resolve) => {
            let loadedCount = 0;
            const totalImages = slides.length;
            
            console.log('🔄 Pré-carregando', totalImages, 'imagens do carrossel...');
            
            slides.forEach((slideUrl, index) => {
                const img = new Image();
                
                img.onload = () => {
                    loadedCount++;
                    console.log(`✅ Imagem ${loadedCount}/${totalImages} carregada`);
                    
                    if (loadedCount === totalImages) {
                        imagesPreloaded = true;
                        console.log('🎉 TODAS as imagens pré-carregadas!');
                        resolve();
                    }
                };
                
                img.onerror = () => {
                    loadedCount++;
                    console.warn(`⚠️ Erro ao carregar: ${slideUrl}`);
                    
                    if (loadedCount === totalImages) {
                        imagesPreloaded = true;
                        resolve();
                    }
                };
                
                // Iniciar carregamento
                img.src = slideUrl;
            });
        });
    }

    // Criar slides (APÓS pré-carregamento)
    function createSlides() {
        slidesContainer.innerHTML = '';
        
        slides.forEach((slideUrl, index) => {
            const slideDiv = document.createElement('div');
            slideDiv.className = `carousel__slide ${index === 0 ? 'active' : ''}`;
            
            const img = document.createElement('img');
            img.src = slideUrl;
            img.alt = `Slide ${index + 1} da Apresentação Institucional`;
            // REMOVER lazy loading - todas as imagens já estão pré-carregadas
            img.loading = 'eager';
            
            // Fallback caso a imagem não exista
            img.onerror = () => {
                console.warn(`Imagem não encontrada: ${slideUrl}`);
                img.src = `https://via.placeholder.com/1200x675/0066cc/ffffff?text=Slide+${index + 1}+-+Adicione+a+imagem`;
                img.alt = `Placeholder Slide ${index + 1}`;
            };
            
            slideDiv.appendChild(img);
            slidesContainer.appendChild(slideDiv);
        });
        
        console.log(`✅ ${slides.length} slides criados no DOM`);
    }

    // Criar indicadores
    function createIndicators() {
        indicatorsContainer.innerHTML = '';
        
        slides.forEach((_, index) => {
            const indicator = document.createElement('button');
            indicator.className = `carousel__indicator ${index === 0 ? 'active' : ''}`;
            indicator.setAttribute('aria-label', `Ir para slide ${index + 1}`);
            indicator.addEventListener('click', () => {
                goToSlide(index);
                resetAutoplay();
            });
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
        const nextIndex = (currentSlide + 1) % slides.length; // Loop infinito
        goToSlide(nextIndex);
    }

    // Slide anterior
    function prevSlide() {
        const prevIndex = (currentSlide - 1 + slides.length) % slides.length; // Loop infinito
        goToSlide(prevIndex);
    }

    // AUTOPLAY com loop infinito
    function startAutoplay() {
        autoplayInterval = setInterval(nextSlide, 5000); // Troca a cada 5 segundos
        console.log('▶️ Autoplay iniciado (5s por slide)');
    }
    
    function stopAutoplay() {
        clearInterval(autoplayInterval);
        console.log('⏸️ Autoplay pausado');
    }
    
    function resetAutoplay() {
        stopAutoplay();
        startAutoplay();
    }

    // Event listeners dos botões
    if (prevBtn) {
        prevBtn.addEventListener('click', () => {
            prevSlide();
            resetAutoplay();
        });
    }
    
    if (nextBtn) {
        nextBtn.addEventListener('click', () => {
            nextSlide();
            resetAutoplay();
        });
    }

    // Pausar autoplay ao hover (desktop)
    if (slidesContainer) {
        slidesContainer.addEventListener('mouseenter', stopAutoplay);
        slidesContainer.addEventListener('mouseleave', startAutoplay);
    }

    // Navegação por teclado
    document.addEventListener('keydown', (e) => {
        if (e.key === 'ArrowLeft') {
            prevSlide();
            resetAutoplay();
        }
        if (e.key === 'ArrowRight') {
            nextSlide();
            resetAutoplay();
        }
    });

    // Touch/swipe para mobile
    let touchStartX = 0;
    let touchEndX = 0;

    slidesContainer.addEventListener('touchstart', (e) => {
        touchStartX = e.changedTouches[0].screenX;
        stopAutoplay();
    }, { passive: true });

    slidesContainer.addEventListener('touchend', (e) => {
        touchEndX = e.changedTouches[0].screenX;
        handleSwipe();
        startAutoplay();
    }, { passive: true });

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

    // Inicializar APÓS pré-carregamento
    async function init() {
        console.log('🚀 Iniciando carrossel de apresentação...');
        
        // Mostrar loading (opcional)
        slidesContainer.innerHTML = '<div style="text-align: center; padding: 50px; color: #0066cc;"><i class="fas fa-spinner fa-spin fa-3x"></i><p style="margin-top: 20px;">Carregando apresentação...</p></div>';
        
        // Aguardar pré-carregamento
        await preloadImages();
        
        // Criar slides no DOM
        createSlides();
        createIndicators();
        updateCounter();
        startAutoplay();
        
        console.log('✅ Carrossel de apresentação inicializado com autoplay!');
    }
    
    // Iniciar
    init();
});
