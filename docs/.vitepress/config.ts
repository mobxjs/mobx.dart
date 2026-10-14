import {readFileSync,readdirSync} from 'node:fs';
import {fileURLToPath} from 'node:url';
import {defineConfigWithTheme,type DefaultTheme} from 'vitepress';
import vueJsx from '@vitejs/plugin-vue-jsx';
import routes from './routes.json';
import pages from './pages.json';
import versions from '../plugins/fetch-versions/published-versions.json';
import {localeOf,localizeLink,type ThemeConfig} from './i18n';
const content=fileURLToPath(new URL('../content/',import.meta.url));
const rewrites:Record<string,string>={...routes,...Object.fromEntries(Object.entries(routes).map(([from,to])=>['ko/'+from,'ko/'+to]))};
const urlOf=(file:string)=>'/'+(rewrites[file]??file).replace(/(^|\/)index\.md$/,'$1').replace(/\.md$/,'');
const plainTitle=(title:string)=>title.replace('🚀','').trim();
const koTitles=new Map((readdirSync(content+'ko',{recursive:true}) as string[]).filter(f=>f.endsWith('.md')).map(f=>{const file='ko/'+f.replaceAll('\\','/');return [urlOf(file),plainTitle(readFileSync(content+file,'utf8').match(/^title:\s*(.+)$/m)?.[1]??'')]}));
const translated=[...koTitles.keys()];
const sections={
 root:{learn:'Learn',start:'Start here',gallery:'Live gallery',examples:'Examples',guides:'Guides',api:'API reference',contributors:'Contributors',community:'Community'},
 ko:{learn:'배우기',start:'여기서 시작하기',gallery:'라이브 갤러리',examples:'예제',guides:'가이드',api:'API 레퍼런스',contributors:'기여자',community:'커뮤니티'},
};
function sidebar(locale:keyof typeof sections):DefaultTheme.SidebarItem[]{
 const s=sections[locale];
 const item=(text:string,link:string)=>{const target=localizeLink(link,locale,translated);return {text:target===link?text:koTitles.get(target)||text,link:target}};
 const page=(source:string)=>{const p=pages.find(p=>p.source===source)!;return item(plainTitle(p.title),p.url)};
 return [
  {text:s.learn,items:[item('Learning path','/learn/'),item('Application architecture','/learn/architecture')]},
  {text:s.start,items:[page('getting-started/index.md'),page('concepts.md')]},
  {text:s.gallery,items:[item('Browse all examples','/gallery/')]},
  {text:s.examples,collapsed:true,items:pages.filter(p=>p.source.startsWith('examples/')).map(p=>page(p.source))},
  {text:s.guides,collapsed:false,items:pages.filter(p=>p.source.startsWith('guides/')).map(p=>page(p.source))},
  {text:s.api,collapsed:false,items:[item('API families','/api/'),item('Collections','/api/collections'),item('Async ownership','/api/async'),item('Flutter integration','/api/flutter'),item('Annotations and tooling','/api/tooling'),item('Extensions','/api/extensions'),item('Adapter APIs','/api/advanced'),item('All mobx members','/api/mobx-public'),item('All Flutter members','/api/flutter_mobx-public'),item('Generator members','/api/mobx_codegen-public'),item('Lint entry point','/api/mobx_lint-public'),...pages.filter(p=>p.source.startsWith('api/')).map(p=>page(p.source))]},
  {text:s.contributors,items:[item('Inside reactivity','/development/reactivity')]},
  {text:s.community,items:[page('community.md'),...pages.filter(p=>p.source.startsWith('development/')).map(p=>page(p.source))]},
 ];
}
const site='https://mobx.vyuh.tech/';
export default defineConfigWithTheme<ThemeConfig>({
 title:'MobX.dart',description:'Friendly, reactive state management for Dart and Flutter.',
 srcDir:'content',outDir:'build',cleanUrls:true,rewrites,
 appearance:true,lastUpdated:true,
 sitemap:{hostname:'https://mobx.vyuh.tech'},
 transformHead({pageData}){
  const path = (routes[pageData.relativePath as keyof typeof routes] ?? pageData.relativePath).replace(/(^|\/)index\.md$/, '$1').replace(/\.md$/, '');
  if(path === '404') return [['meta',{name:'robots',content:'noindex'}]];
  const url = site + path;
  const ko = localeOf(path) === 'ko';
  const title = `${pageData.title || (ko ? '친근한 반응형 상태 관리' : 'Friendly, reactive state management')} | MobX.dart`;
  const description = pageData.description || (ko ? 'Dart와 Flutter를 위한 친근한 반응형 상태 관리. MobX로 상태, computed 값, UI를 연결하세요.' : 'Friendly, reactive state management for Dart and Flutter. Connect state, computed values, and your UI with MobX.');
  const english = ko ? path.replace(/^ko\/?/, '') : path, korean = 'ko/' + english;
  const alternates = translated.includes('/' + korean) ? {en: english, ko: korean, 'x-default': english} : {};
  const image = 'https://mobx.vyuh.tech/images/social-card.jpg';
  const alt = 'MobX.dart — Big ideas. Simple state. Action connects to Observable, which connects to Reaction.';
  return [
   ['link',{rel:'canonical',href:url}],
   ...Object.entries(alternates).map(([hreflang,href]):[string,Record<string,string>]=>['link',{rel:'alternate',hreflang,href:site+href}]),
   ...Object.entries({'og:type':'website','og:site_name':'MobX.dart','og:locale':ko?'ko_KR':'en_US','og:title':title,'og:description':description,'og:url':url,'og:image':image,'og:image:secure_url':image,'og:image:type':'image/jpeg','og:image:width':'1200','og:image:height':'630','og:image:alt':alt}).map(([property,content]):[string,Record<string,string>]=>['meta',{property,content}]),
   ...Object.entries({'twitter:card':'summary_large_image','twitter:title':title,'twitter:description':description,'twitter:image':image,'twitter:image:alt':alt}).map(([name,content]):[string,Record<string,string>]=>['meta',{name,content}]),
  ];
 },
 head:[['link',{rel:'icon',href:'/mobx.png'}],['script',{},`try { if (!localStorage.getItem('vitepress-theme-appearance')) localStorage.setItem('vitepress-theme-appearance', 'light'); } catch {}`]],
 locales:{
  root:{label:'English',lang:'en-US'},
  ko:{label:'한국어',lang:'ko-KR',link:'/ko/',description:'Dart와 Flutter를 위한 친근한 반응형 상태 관리.',themeConfig:{
   nav:[{text:'문서',link:'/ko/getting-started'},{text:'예제',link:'/gallery/'}],
   sidebar:sidebar('ko'),translated,
   editLink:{pattern:'https://github.com/mobxjs/mobx.dart/edit/main/docs/content/:path',text:'이 페이지 개선하기'},
   footer:{message:'Dart와 Flutter 커뮤니티를 위해 정성껏 만들었습니다. MIT 라이선스.',copyright:`Copyright © 2018–${new Date().getFullYear()} MobX.dart contributors.`},
   outline:{level:[2,3],label:'이 페이지 목차'},
   lastUpdated:{text:'마지막 업데이트',formatOptions:{dateStyle:'medium'}},
   docFooter:{prev:'이전 페이지',next:'다음 페이지'},
   langMenuLabel:'언어 변경',returnToTopLabel:'맨 위로',sidebarMenuLabel:'메뉴',darkModeSwitchLabel:'테마',lightModeSwitchTitle:'라이트 모드로 전환',darkModeSwitchTitle:'다크 모드로 전환',skipToContentLabel:'본문으로 건너뛰기',
  }},
 },
 themeConfig:{
  lastUpdated:{formatOptions:{dateStyle:'medium'}},
  logo:{src:'/mobx.svg',alt:'MobX.dart'},siteTitle:'MobX.dart',
  nav:[{text:'Docs',link:'/getting-started'},{text:'Examples',link:'/gallery/'}],
  socialLinks:[{icon:'github',link:'https://github.com/mobxjs/mobx.dart'},{icon:'discord',link:'https://discord.gg/dNHY52k'}],
  search:{provider:'local',options:{locales:{ko:{translations:{
   button:{buttonText:'검색',buttonAriaLabel:'검색'},
   modal:{displayDetails:'자세히 보기',resetButtonTitle:'검색어 지우기',backButtonTitle:'검색 닫기',noResultsText:'검색 결과가 없습니다',footer:{selectText:'선택',navigateText:'이동',closeText:'닫기'}},
  }}}}},
  sidebar:sidebar('root'),
  editLink:{pattern:'https://github.com/mobxjs/mobx.dart/edit/main/docs/content/:path',text:'Improve this page'},
  footer:{message:'Made with care for the Dart & Flutter community. MIT licensed.',copyright:`Copyright © 2018–${new Date().getFullYear()} MobX.dart contributors.`},
  outline:[2,3],
 },
 markdown:{config(md){const original=md.renderer.rules.fence!;md.renderer.rules.fence=(tokens,index,options,env,self)=>{tokens[index].content=tokens[index].content.replace(/{{\s*(\w+)\s*}}/g,(text,key)=>versions[key as keyof typeof versions]??text);return original(tokens,index,options,env,self);};}},
 vite:{server:{watch:{usePolling:true,interval:400}},publicDir:fileURLToPath(new URL('../public',import.meta.url)),plugins:[vueJsx()]},
});
