(function () {
    const canvas = document.getElementById('hero3d');
    if (!canvas) return;

    // Fixed canvas size
    const width = 300;
    const height = 300;

    // Scene
    const scene = new THREE.Scene();

    // Camera
    const camera = new THREE.PerspectiveCamera(45, width / height, 0.1, 1000);
    camera.position.set(0, 0.1, 4);

    // Renderer (transparent background)
    const renderer = new THREE.WebGLRenderer({ canvas: canvas, alpha: true, antialias: true });
    renderer.setSize(width, height);
    renderer.setPixelRatio(window.devicePixelRatio);
    renderer.setClearColor(0x000000, 0);

    // Lighting
    const ambientLight = new THREE.AmbientLight(0xffffff, 0.8);
    scene.add(ambientLight);

    const directionalLight = new THREE.DirectionalLight(0xffffff, 0.6);
    directionalLight.position.set(2, 3, 4);
    scene.add(directionalLight);

    // contextPath from mainFilterConfig (defined in index.jsp inline script)
    const basePath = (window.mainFilterConfig && window.mainFilterConfig.contextPath) ? window.mainFilterConfig.contextPath : '';
    const textureLoader = new THREE.TextureLoader();

    textureLoader.load(basePath + '/static/img/hero/bicycle.png', function (texture) {
        texture.minFilter = THREE.LinearFilter;
        texture.magFilter = THREE.NearestFilter;

        const imgAspect = texture.image.width / texture.image.height;
        const planeWidth = 2; // hero3d 사이즈 줄이기
        const planeHeight = planeWidth / imgAspect;

        // Front plane
        const geometry = new THREE.PlaneGeometry(planeWidth, planeHeight);
        const material = new THREE.MeshBasicMaterial({
            map: texture,
            transparent: true,
            side: THREE.DoubleSide
        });
        const plane = new THREE.Mesh(geometry, material);
        plane.position.y = 0.3;
        scene.add(plane);

        // Animation
        const clock = new THREE.Clock();

        function animate() {
            requestAnimationFrame(animate);
            const elapsed = clock.getElapsedTime();

            // Y-axis rotation (살짝 비스듬히 고정)
            plane.rotation.y =  (Math.sin(elapsed * 0.8) + 1) / 2 * (Math.PI / 4);

            // Floating effect
            plane.position.y = Math.sin(elapsed * 1.5) * 0;

            renderer.render(scene, camera);
        }

        animate();
    }, undefined, function (err) {
        console.error('Hero3D texture load error:', err);
    });

    // Resize handling
    window.addEventListener('resize', function () {
        const container = canvas.parentElement;
        if (container) {
            const w = Math.min(container.clientWidth, 500) || 500;
            camera.aspect = w / height;
            camera.updateProjectionMatrix();
            renderer.setSize(w, height);
        }
    });
})();
