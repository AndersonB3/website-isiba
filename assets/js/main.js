/*=============== SHOW MENU ===============*/
const navMenu = document.getElementById('nav-menu');
const navToggle = document.getElementById('nav-toggle');
const navClose = document.getElementById('nav-close');

// Menu show
if (navToggle) {
    navToggle.addEventListener('click', () => {
        navMenu.classList.add('show-menu');
    });
}

// Menu hidden
if (navClose) {
    navClose.addEventListener('click', () => {
        navMenu.classList.remove('show-menu');
    });
}

/*=============== REMOVE MENU MOBILE ===============*/
const navLink = document.querySelectorAll('.nav__link');

const linkAction = () => {
    const navMenu = document.getElementById('nav-menu');
    navMenu.classList.remove('show-menu');
};
navLink.forEach(n => n.addEventListener('click', linkAction));

/*=============== CHANGE BACKGROUND HEADER ===============*/
const scrollHeader = () => {
    const header = document.getElementById('header');
    if (this.scrollY >= 50) {
        header.classList.add('scroll-header');
    } else {
        header.classList.remove('scroll-header');
    }
};
window.addEventListener('scroll', scrollHeader);

/*=============== SCROLL SECTIONS ACTIVE LINK ===============*/
const sections = document.querySelectorAll('section[id]');

const scrollActive = () => {
    const scrollY = window.pageYOffset;

    sections.forEach(current => {
        const sectionHeight = current.offsetHeight;
        const sectionTop = current.offsetTop - 100;
        const sectionId = current.getAttribute('id');
        const sectionsClass = document.querySelector('.nav__menu a[href*=' + sectionId + ']');

        if (scrollY > sectionTop && scrollY <= sectionTop + sectionHeight) {
            if (sectionsClass) {
                sectionsClass.classList.add('active-link');
            }
        } else {
            if (sectionsClass) {
                sectionsClass.classList.remove('active-link');
            }
        }
    });
};
window.addEventListener('scroll', scrollActive);

/*=============== SHOW SCROLL UP ===============*/
const scrollUp = () => {
    const scrollUp = document.getElementById('scroll-top');
    if (this.scrollY >= 350) {
        scrollUp.classList.add('show-scroll');
    } else {
        scrollUp.classList.remove('show-scroll');
    }
};
window.addEventListener('scroll', scrollUp);

/*=============== SCROLL TO TOP ===============*/
const scrollTopBtn = document.getElementById('scroll-top');
if (scrollTopBtn) {
    scrollTopBtn.addEventListener('click', () => {
        window.scrollTo({
            top: 0,
            behavior: 'smooth'
        });
    });
}

/*=============== SCROLL REVEAL ANIMATION ===============*/
// Initialize AOS
if (typeof AOS !== 'undefined') {
    AOS.init({
        duration: 1000,
        easing: 'ease-in-out',
        once: true,
        offset: 100
    });
}

/*=============== COUNTER ANIMATION ===============*/
const speed = 200;

const animateCounter = () => {
    const counters = document.querySelectorAll('.stat__number');
    counters.forEach(counter => {
        const updateCount = () => {
            const target = +counter.getAttribute('data-target');
            const count = +counter.innerText.replace(/\./g, '').replace(',', '.');
            const increment = target / speed;

            if (count < target) {
                counter.innerText = Math.ceil(count + increment);
                setTimeout(updateCount, 10);
            } else {
                counter.innerText = target.toLocaleString('pt-BR');
            }
        };
        updateCount();
    });
};

// Carregar valores do Supabase e iniciar animação
const carregarEstatisticasDoSupabase = async () => {
    const counterSection = document.querySelector('.stats');
    if (!counterSection) return;

    // Tentar buscar do Supabase
    try {
        if (window.supabaseClient) {
            const { data, error } = await window.supabaseClient
                .from('configuracoes_site')
                .select('id, valor')
                .in('id', [
                    'stat_atendimentos',
                    'stat_unidades',
                    'stat_profissionais',
                    'stat_satisfacao',
                    'relatorio_subtitulo',
                    'relatorio_titulo',
                    'relatorio_descricao'
                ]);

            if (!error && data && data.length > 0) {
                const cfg = {};
                data.forEach(row => { cfg[row.id] = row.valor; });

                // Atualizar data-target dos cards
                const mapa = [
                    'stat_atendimentos',
                    'stat_unidades',
                    'stat_profissionais',
                    'stat_satisfacao'
                ];
                const nums = document.querySelectorAll('.stat__number[data-target]');
                nums.forEach((el, i) => {
                    if (cfg[mapa[i]] !== undefined) {
                        el.setAttribute('data-target', cfg[mapa[i]]);
                    }
                });

                // Atualizar textos da seção
                const subtitle = document.querySelector('#relatorio .section__subtitle');
                const title    = document.querySelector('#relatorio .section__title');
                const desc     = document.querySelector('#relatorio .section__description');
                if (subtitle && cfg['relatorio_subtitulo']) subtitle.textContent = cfg['relatorio_subtitulo'];
                if (title    && cfg['relatorio_titulo'])    title.textContent    = cfg['relatorio_titulo'];
                if (desc     && cfg['relatorio_descricao']) desc.textContent     = cfg['relatorio_descricao'];

                console.log('✅ Estatísticas carregadas do Supabase');
            }
        }
    } catch (e) {
        console.warn('⚠️ Usando valores padrão do HTML (Supabase indisponível):', e.message);
    }

    // Intersection Observer — iniciar animação quando seção aparecer
    const counterObserver = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                animateCounter();
                counterObserver.unobserve(entry.target);
            }
        });
    }, { threshold: 0.5 });

    counterObserver.observe(counterSection);
};

// Aguardar Supabase inicializar e então carregar
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', carregarEstatisticasDoSupabase);
} else {
    setTimeout(carregarEstatisticasDoSupabase, 300);
}

/*=============== VIDEO MODAL ===============*/
const videoModal = document.getElementById('video-modal');
const playVideoBtn = document.getElementById('play-video');
const closeModalBtn = document.getElementById('close-modal');
const videoPlayer = document.getElementById('video-player');
const modalOverlay = document.querySelector('.modal__overlay');

// Open modal and play video
if (playVideoBtn) {
    playVideoBtn.addEventListener('click', () => {
        videoModal.classList.add('show-modal');
        document.body.style.overflow = 'hidden';
        // Auto play quando abrir o modal
        if (videoPlayer) {
            videoPlayer.play();
        }
    });
}

// Close modal
const closeModal = () => {
    videoModal.classList.remove('show-modal');
    document.body.style.overflow = 'auto';
    // Pausar e resetar o vídeo quando fechar
    if (videoPlayer) {
        videoPlayer.pause();
        videoPlayer.currentTime = 0;
    }
};

if (closeModalBtn) {
    closeModalBtn.addEventListener('click', closeModal);
}

if (modalOverlay) {
    modalOverlay.addEventListener('click', closeModal);
}

// Close modal with ESC key
document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape' && videoModal.classList.contains('show-modal')) {
        closeModal();
    }
});

/*=============== SMOOTH SCROLL FOR ANCHOR LINKS ===============*/
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        const href = this.getAttribute('href');
        
        // Ignore links that are just "#"
        if (href === '#') return;
        
        e.preventDefault();
        const target = document.querySelector(href);
        
        if (target) {
            const headerHeight = document.querySelector('.header').offsetHeight;
            const targetPosition = target.offsetTop - headerHeight;
            
            window.scrollTo({
                top: targetPosition,
                behavior: 'smooth'
            });
        }
    });
});

/*=============== FORM VALIDATION (if needed in future) ===============*/
const validateEmail = (email) => {
    const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return re.test(email);
};

/*=============== PRELOADER (optional) ===============*/
window.addEventListener('load', () => {
    const preloader = document.querySelector('.preloader');
    if (preloader) {
        setTimeout(() => {
            preloader.style.opacity = '0';
            setTimeout(() => {
                preloader.style.display = 'none';
            }, 500);
        }, 1000);
    }
});

/*=============== CONSOLE BRANDING ===============*/
console.log('%c🏥 ISIBA', 'font-size: 20px; font-weight: bold; color: #0891b2;');
console.log('%cGestão Humanizada em Saúde Pública', 'font-size: 14px; color: #059669;');
console.log('%cWebsite desenvolvido com ❤️', 'font-size: 12px; color: #6b7280;');
