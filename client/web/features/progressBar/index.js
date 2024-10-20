const progressBar = document.querySelector('.progress');
const progressText = document.getElementById('progress-text');
const circleProgress = document.querySelector('.progress-circle-holder');
const verticalProgress = document.querySelector('.progress-vertical-holder');
const horizontalProgress = document.querySelector('.progress-horizontal-holder');
const circle = Math.PI * 90;
progressBar.style.strokeDasharray = circle;
progressBar.style.strokeDashoffset = circle;

let circleInterval, horizontalInterval, verticalInterval;

function wait(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
};

function updateProgress(value) {
    progressBar.style.strokeDashoffset = circle - (value / 100) * circle;
    progressText.textContent = `${value}%`;
};

function animateCircleProgress(duration) {
    clearInterval(circleInterval);
    let value = 0;
    circleInterval = setInterval(() => {
        if (value <= 100) {
            updateProgress(value);
            value++;
        } else {
            clearInterval(circleInterval);
            updateProgress(0);

            value = 0;
            circleProgress.style.display = 'none';
        }
    }, duration / 100);
};

async function animateHVProgress(type, duration) {
    clearInterval(type == 'vertical' ? verticalInterval : horizontalInterval);

    const progressBar = type == 'vertical' ? verticalProgress : horizontalProgress, progressName = `.progress-bar-${type}`, markup = type == 'vertical' ? 0.2 : 0.25;
    let progress = markup, percentage = 0, setIntervalFun = setInterval(() => {
        if (percentage < 100) {
            $(progressName)[type == 'vertical' ? 'height' : 'width'](JSON.stringify(progress) + 'vh');

            progress += markup;
            percentage++;
        } else {
            clearInterval(type == 'vertical' ? verticalInterval : horizontalInterval);

            $(progressName).height('0vh')
            progressBar.style.display = 'none';
        };
    }, duration / 100);
    if (type == 'vertical') {
       verticalInterval = setIntervalFun
    } else {
        horizontalInterval = setIntervalFun
    };
};

window.addEventListener('message', function(event) {
    const data = event.data;
    if (data.action === 'progressBar') {
        if (data.barType === 'circle') {
            circleProgress.style.display = 'flex';

            if (data.duration) {
                animateCircleProgress(data.duration);
            };

            if (data.position) {
                setProgressBarPosition('circle', data.position);
            };
        } else if (data.barType === 'vertical') {
            verticalProgress.style.display = 'flex';

            if (data.content) {
                verticalProgress.querySelector('.progress-vertical-text').textContent = data.content;
            };

            if (data.duration) {
                animateHVProgress('vertical', data.duration);
            };

            if (data.position) {
                setProgressBarPosition('vertical', data.position);
            };
        } else if (data.barType === 'horizontal') {
            horizontalProgress.style.display = 'flex';

            if (data.content) {
                horizontalProgress.querySelector('.progress-horizontal-text').textContent = data.content;
            };

            if (data.duration) {
                animateHVProgress('horizontal', data.duration);
            };

            if (data.position) {
                setProgressBarPosition('horizontal', data.position);
            };
        };
    };
});

const setProgressBarPosition = (progressType, position) => {
    let posCss = {};
    let element;
    const vh = Math.max(document.documentElement.clientHeight, window.innerHeight || 0);
    const offset = 10;
    position = position ? position : resp.defaultProgressBarPosition;

    switch (progressType) {
        case 'circle':
            element = circleProgress;
            break;
        case 'vertical':
            element = verticalProgress;
            break;
        case 'horizontal':
            element = horizontalProgress;
            break;
        default:
            return;
    };

    const centerHeight = (vh / 2) - (element.offsetHeight / 2);
    const centerWidth = (Math.max(document.documentElement.clientWidth, window.innerWidth || 0) / 2) - (element.offsetWidth / 2);
    switch (position) {
        case 'center-left':
            posCss = { top: `${centerHeight}px`, left: `${offset}px` };
            break;
        case 'center':
            posCss = { top: `${centerHeight}px`, left: `${centerWidth}px` }
            break;
        case 'center-right':
            posCss = { top: `${centerHeight}px`, right: `${offset}px` };
            break;
        case 'bottom-left':
            posCss = { bottom: `${offset}px`, left: `${offset}px` };
            break;
        case 'bottom-center':
            posCss = { botton: `${offset}px`, left: `${centerWidth}px` };
            break;
        case 'bottom-right':
            posCss = { bottom: `${offset}px`, right: `${offset}px` };
            break;
        default:
            posCss = { top: `${offset}px`, right: `${offset}px` };
            break;
    };

    Object.assign(element.style, posCss);
};