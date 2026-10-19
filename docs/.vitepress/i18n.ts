import type {DefaultTheme} from 'vitepress';
// Pages without a translation stay in English at the site root, so locale links fall back to them.
export type ThemeConfig=DefaultTheme.Config&{translated?:string[]};
export const localeOf=(path:string)=>/^\/?ko(\/|$)/.test(path)?'ko':'root';
export function localizeLink(url:string,locale:string,translated:readonly string[]=[]){
 if(locale==='root'||!url.startsWith('/'))return url;
 const [path,hash]=url.split('#'),target='/'+locale+path;
 return translated.includes(target)?target+(hash===undefined?'':'#'+hash):url;
}
