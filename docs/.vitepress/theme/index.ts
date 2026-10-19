import DefaultTheme from 'vitepress/theme-without-fonts';
import {defineComponent,h} from 'vue';
import {useData,type Theme} from 'vitepress';
import HomePage from './components/HomePage';
import FlutterExample from './components/FlutterExample.vue';
import ExampleGallery from './components/ExampleGallery.vue';
import PubBadge from './components/PubBadge.vue';
import {Profile} from './components/Profile';
import LocaleNotFound from './components/LocaleNotFound.vue';
import './custom.css';
import './home.css';
import {initAnalytics,trackEvent} from './analytics';
// Translated locales explain that a missing page may still exist in English; the root locale keeps the default 404.
const Layout=defineComponent(()=>{const {localeIndex}=useData();return ()=>h(DefaultTheme.Layout,null,{'not-found':()=>localeIndex.value==='root'?undefined:h(LocaleNotFound)});});
export default {extends:DefaultTheme,Layout,enhanceApp({app,router}){
 initAnalytics();
 const previous = router.onAfterRouteChanged;
 router.onAfterRouteChanged = (to) => {
  previous?.(to);
  trackEvent('docs_navigation', {destination: new URL(to, 'https://mobx.vyuh.tech').pathname});
 };
 app.component('HomePage',HomePage);app.component('FlutterExample',FlutterExample);app.component('ExampleGallery',ExampleGallery);app.component('PubBadge',PubBadge);app.component('Profile',Profile);
}} satisfies Theme;
