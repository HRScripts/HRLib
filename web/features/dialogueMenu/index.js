window.addEventListener('message', (event) => {
    const data = event.data.data;
    switch(event.data.action) {
        case 'alertDialogue':
            $('.alertDialogue-menu').css({
                display: 'flex',
                'margin-top': ((Math.max(document.documentElement.clientHeight, window.innerHeight || 0) / 2) - ($('.alertDialogue-menu')[0].offsetHeight / 2)) + 'px',
                'margin-left': ((Math.max(document.documentElement.clientWidth, window.innerWidth || 0) / 2) - ($('.alertDialogue-menu')[0].offsetWidth / 2) + ($('.alertDialogue-menu')[0].offsetWidth / 2)) + 'px'
            });
            $('.inputDialog-menu').css('display', 'none');

            $('.alertDialogue-title').text(data.title);
            $('.alertDialogue-description').text(data.description);

            $.post('https://HRLib/getButtonsTranslation', JSON.stringify({ type: 'alert' }), (response) => {
                $('.alertDialogue-button').text(response.confirmLabel);
                $('.alertDialogue-button-cancel').text(response.cancelLabel);
            }, 'json');

            ([ '.alertDialogue-button', '.alertDialogue-button-cancel' ]).forEach(function(value) {
                $(value).off('click').on('click', function() {
                    $.post('https://HRLib/closeDialogue', JSON.stringify({ dialogueType: 'alert', type: value.includes('cancel') ? 'cancel' : 'agree' }));
                    $('.alertDialogue-title').text('');
                    $('.alertDialogue-description').text('');
                    $('.alertDialogue-menu').hide();
                });
            });

            break;
        case 'inputDialogue':
            $('.inputDialogue-menu').show();
            $('.inputDialogue-title').text(data.title || '');
            $('.inputDialogue-menu').css({
                'margin-top': ((Math.max(document.documentElement.clientHeight, window.innerHeight || 0) / 2) - ($('inputDialogue-menu').outerHeight())) + 'px',
                'margin-left': (Math.max(document.documentElement.clientWidth, window.innerWidth || 0) - $('.inputDialogue-menu')[0].offsetWidth + $('.inputDialogue-menu')[0].offsetWidth) / 2 + 'px'
            });

            $.post('https://HRLib/getButtonsTranslation', JSON.stringify({ type: 'input' }), (response) => {
                $('.submit-button').text(response.confirmLabel);
                $('.close-button').text(response.cancelLabel);
            }, 'json');

            if (Array.isArray(data.questions)) {
                data.questions.forEach(function(value, i) {
                    if (value.type !== 'text' && value.type !== 'number') {
                        console.error(`The entered type for ${i+1} option in created input dialogue is invalid!`);
                        return;
                    };

                    const currQuestion = $(`<div class="input"><p class="input-description">${value.options.label}</p><input type="${value.type}" placeholder="${value.options.placeholder || ''}"></div>`);
                    $('.inputs').append(currQuestion);
                });
            };

            ([ '.submit-button', '.close-button' ]).forEach(function(value) {
                $(value).off('click').on('click', function() {
                    const values = [];

                    Array.from($('.inputs').find('input')).forEach(function(value) {
                        values.push(value.type === 'number' ? (typeof value.value !== 'number' ? Number(value.value) : value.value) : value.value);
                    });

                    $.post('https://HRLib/closeDialogue', JSON.stringify({ dialogueType: 'input', type: value.includes('close') ? 'cancel' : 'agree', answers: value.includes('close') ? null : values }));
                    $('.input-title').text('');
                    $('.inputDialogue-menu').hide();

                    $('.inputs')[0].innerHTML = '';
                });
            });

            break;
        default:
            break;
    };
});