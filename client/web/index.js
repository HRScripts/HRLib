const positions = {
    'top-right': 10,
    'center-right': 10,
    'bottom-right': 10,
    'top-left': 10,
    'left-center': 10,
    'bottom-left': 10,
};

const setPosition = (notification, position) => {
    let posCss = {};
    const vh = Math.max(document.documentElement.clientHeight, window.innerHeight || 0);
    const offset = 10;
    const curr = positions[position];

    switch (position) {
        case 'top-right':
            posCss = { top: `${curr}px`, right: `${offset}px` };
            break;
        case 'center-right':
            posCss = { top: `${(vh / 2) - (notification.outerHeight() / 2) + curr}px`, right: `${offset}px` };
            break;
        case 'bottom-right':
            posCss = { bottom: `${curr}px`, right: `${offset}px` };
            break;
        case 'top-left':
            posCss = { top: `${curr}px`, left: `${offset}px` };
            break;
        case 'left-center':
            posCss = { top: `${(vh / 2) - (notification.outerHeight() / 2) + curr}px`, left: `${offset}px` };
            break;
        case 'bottom-left':
            posCss = { bottom: `${curr}px`, left: `${offset}px` };
            break;
        default:
            console.log('Invalid position specified. Defaulting to top-right.');
            posCss = { top: `${positions['top-right']}px`, right: `${offset}px` };
            break;
    }

    notification.css(posCss);
    positions[position] += notification.outerHeight() + 10;
};

window.addEventListener('message', function (event) {
    const type = event.data.type;
    const msg = event.data.text;
    const time = event.data.time || 4500;
    const position = event.data.position || 'top-right';

    const notification = $(`<div position=${position} class="notification enter">`)
        .addClass(type)
        .appendTo('.notifications');

    if (event.data.sound) {
        const sound = new Audio('sound.wav');
        sound.volume = 0.2;

        sound.play()
    }

    $('<div class="notification-text">')
        .text(msg)
        .appendTo(notification);

    const progressBar = $('<div class="progress-bar">').appendTo(notification);

    switch (type) {
        case 'success':
            progressBar.css('background-color', '#28a745');
            break;
        case 'info':
            progressBar.css('background-color', '#17a2b8');
            break;
        case 'error':
            progressBar.css('background-color', '#dc3545');
            break;
        case 'warning':
            progressBar.css('background-color', '#ffc107');
            break;
        default:
            progressBar.css('background-color', '#6c757d');
            break;
    }

    progressBar.width('100%');

    setPosition(notification, position);

    progressBar.animate({ width: '0%' }, time, "linear", function() {
        notification.removeClass('enter').addClass('exit');
        setTimeout(function() {
            notification.remove();

            if (!$('.notifications').find(`div[position="${position}"]`).length) {
                positions[position] = 10;
            };
        }, 500);
    });

}, false);