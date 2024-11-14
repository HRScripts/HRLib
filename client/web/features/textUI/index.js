const container = document.querySelector('.text-ui-container');
const buttonText = document.querySelector('.text-ui-button');

window.addEventListener('message', function(event) {
    const data = event.data;
    if (data.action === 'textUI') {
        container.classList[data.visible ? 'add' : 'remove']('visible');

        if (data.content) {
            buttonText.innerText = data.content;
        };
    } else if (data.action === 'getTextUIStatus') {
        $.post('https://HRLib/getTextUIStatus', JSON.stringify({ status: container.classList.contains('visible'), content: buttonText.innerText }), () => {}, 'json')
    };
});