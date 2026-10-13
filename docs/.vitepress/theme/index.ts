import DefaultTheme from 'vitepress/theme-without-fonts';
import type {Theme} from 'vitepress';
import HomePage from './components/HomePage';
import FlutterExample from './components/FlutterExample.vue';
import ExampleGallery from './components/ExampleGallery.vue';
import PubBadge from './components/PubBadge.vue';
import {Profile} from './components/Profile';
import './custom.css';
import './home.css';
import {initAnalytics,trackEvent} from './analytics';
export default {extends:DefaultTheme,enhanceApp({app,router}){
 initAnalytics();
 const previous = router.onAfterRouteChanged;
 router.onAfterRouteChanged = (to) => {
  previous?.(to);
  trackEvent('docs_navigation', {destination: new URL(to, 'https://mobx.vyuh.tech').pathname});
 };
 app.component('HomePage',HomePage);app.component('FlutterExample',FlutterExample);app.component('ExampleGallery',ExampleGallery);app.component('PubBadge',PubBadge);app.component('Profile',Profile);
}} satisfies Theme;
