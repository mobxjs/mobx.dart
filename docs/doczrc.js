export default {
    title: "MobX.dart",
    description:
        "The MobX state-management library for building Dart and Flutter Apps.",
    src: "./src",
    files: "**/*.{md,markdown,mdx}",
    repository: "https://github.com/mobxjs/mobx.dart",
    indexHtml: "src/index.html",
    themeConfig: {
        logo: {
            src:
                "https://raw.githubusercontent.com/mobxjs/mobx.dart/master/docs/src/images/mobx.png"
        },
        mode: "light",
        colors: {
            primary: "#1389FD",
            codeColor: "#fa6000",
            blockquoteColor: "#00579b"
        },
        styles: {
            code: `
            font-size: 1em;
            padding: 0.1rem 0.5rem;
            `
        }
    },
    menu: [
        "Home",
        "Getting Started",
        "Core Concepts",
        "Examples",
        "Guides",
        "Community",
        "API Overview"
    ]
};
