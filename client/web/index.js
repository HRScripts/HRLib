import 'nui://game/ui/jquery.js';

const modules = [ 'textUI', 'notify', 'progressBar', 'dialogueMenu' ];
for (let i = 0; i <= modules.length-1; i++) {
    import(`./features/${modules[i]}/index.js`);
};