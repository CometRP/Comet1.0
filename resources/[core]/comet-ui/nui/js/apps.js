AppsStatus = {};
RegisteredApps = [
    {
        app: 'Prompts',
        html: ['index.html'],
        css: ['main.css'],
        js: ['main.js'],
        status: false,
    },
    {
        app: 'Scope',
        html: ['index.html'],
        css: ['main.css'],
        js: ['main.js'],
        status: false,
    },
    {
        app: 'Context',
        html: ['index.html'],
        css: ['main.css'],
        js: ['main.js'],
        status: false,
    },
    {
        app: 'Sounds',
        html: [],
        css: ['main.css'],
        js: ['howler.min.js', 'howler.spatial.min.js', 'main.js'],
        status: false,
    },
    {
        app: 'Progress',
        html: ['index.html'],
        css: ['main.css'],
        js: ['main.js'],
        status: false,
    },
    {
        app: 'Input',
        html: ['index.html'],
        css: ['main.css'],
        js: ['main.js'],
        status: false,
    },
    {
        app: 'Info',
        html: ['index.html'],
        css: ['main.css'],
        js: ['main.js'],
        status: false,
    },
    {
        app: 'Minigames',
        html: ['index.html'],
        css: ['main.css'],
        js: ['main.js', 'memory.js', 'color.js', 'figure.js', 'boosting.js'],
        status: false,
    },
];

RegisterAllApps = () => {
    $('#root').empty();
    
    for (let i = 0; i < RegisteredApps.length; i++) {
        const elem = RegisteredApps[i];
        
        AppsStatus[elem.app] = false;

        CreateApp(elem.app, elem.html, elem.css, elem.js);

        setTimeout(() => {
            if (AppsStatus[elem.app] == false) {   
                OnNuiEvent('Prompts', 'CreatePrompt', {
                    text: `Failed to build app '${elem.app}', please report this.`,
                    color: "error",
                    duration: 10000,
                    id: 'ui-create-error',
                })
            }
        }, 5000);
    }
}

SetAppStatus = (app, status) => {
    AppsStatus[app] = status;
}