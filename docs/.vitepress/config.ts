import {fileURLToPath} from 'node:url';
import {defineConfig} from 'vitepress';
import vueJsx from '@vitejs/plugin-vue-jsx';
import routes from './routes.json';
import pages from './pages.json';
import versions from '../plugins/fetch-versions/published-versions.json';
const page=(source:string)=>{const p=pages.find(p=>p.source===source)!;return {text:p.title.replace('🚀','').trim(),link:p.url}};
export default defineConfig({
 title:'MobX.dart',description:'Friendly, reactive state management for Dart and Flutter.',
 srcDir:'content',outDir:'build',cleanUrls:true,rewrites:routes,
 appearance:true,lastUpdated:true,
 sitemap:{hostname:'https://mobx.vyuh.tech'},
 head:[['link',{rel:'icon',href:'/mobx.png'}],['script',{},`try { if (!localStorage.getItem('vitepress-theme-appearance')) localStorage.setItem('vitepress-theme-appearance', 'light'); } catch {}`]],
 themeConfig:{
  lastUpdated:{formatOptions:{dateStyle:'medium'}},
  logo:{src:'/mobx.svg',alt:'MobX.dart'},siteTitle:'MobX.dart',
  nav:[{text:'Docs',link:'/getting-started'},{text:'Examples',link:'/gallery/'}],
  socialLinks:[{icon:'github',link:'https://github.com/mobxjs/mobx.dart'},{icon:'discord',link:'https://discord.gg/dNHY52k'}],
  search:{provider:'local'},
  sidebar:[
   {text:'Learn',items:[{text:'Learning path',link:'/learn/'},{text:'Application architecture',link:'/learn/architecture'}]},
   {text:'Start here',items:[page('getting-started/index.md'),page('concepts.md')]},
   {text:'Live gallery',items:[{text:'Browse all examples',link:'/gallery/'}]},
   {text:'Examples',collapsed:true,items:pages.filter(p=>p.source.startsWith('examples/')).map(p=>page(p.source))},
   {text:'Guides',collapsed:false,items:pages.filter(p=>p.source.startsWith('guides/')).map(p=>page(p.source))},
   {text:'API reference',collapsed:false,items:[{text:'API families',link:'/api/'},{text:'Collections',link:'/api/collections'},{text:'Async ownership',link:'/api/async'},{text:'Flutter integration',link:'/api/flutter'},{text:'Annotations and tooling',link:'/api/tooling'},{text:'Extensions',link:'/api/extensions'},{text:'Adapter APIs',link:'/api/advanced'},{text:'All mobx members',link:'/api/mobx-public'},{text:'All Flutter members',link:'/api/flutter_mobx-public'},{text:'Generator members',link:'/api/mobx_codegen-public'},{text:'Lint entry point',link:'/api/mobx_lint-public'},...pages.filter(p=>p.source.startsWith('api/')).map(p=>page(p.source))]},
   {text:'Contributors',items:[{text:'Inside reactivity',link:'/development/reactivity'}]},
   {text:'Community',items:[page('community.md'),...pages.filter(p=>p.source.startsWith('development/')).map(p=>page(p.source))]},
  ],
  editLink:{pattern:'https://github.com/mobxjs/mobx.dart/edit/main/docs/content/:path',text:'Improve this page'},
  footer:{message:'Made with care for the Dart & Flutter community. MIT licensed.',copyright:`Copyright © 2018–${new Date().getFullYear()} MobX.dart contributors.`},
  outline:[2,3],
 },
 markdown:{config(md){const original=md.renderer.rules.fence!;md.renderer.rules.fence=(tokens,index,options,env,self)=>{tokens[index].content=tokens[index].content.replace(/{{\s*(\w+)\s*}}/g,(text,key)=>versions[key as keyof typeof versions]??text);return original(tokens,index,options,env,self);};}},
 vite:{server:{watch:{usePolling:true,interval:400}},publicDir:fileURLToPath(new URL('../public',import.meta.url)),plugins:[vueJsx()]},
});
