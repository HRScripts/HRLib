import 'nui://game/ui/jquery.js';

const modules = [ 'textUI', 'notify', 'progressBar' ];
for (let i = 0; i <= modules.length-1; i++) {
    import(`./features/${modules[i]}/index.js`);
};