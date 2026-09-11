const measurementId = 'G-HD7VP109DL';
declare global {
 interface Window {dataLayer?: unknown[];gtag?: (...args: unknown[]) => void}
}

export function initAnalytics() {
 if (typeof window === 'undefined' || location.hostname !== 'mobx.vyuh.tech' || window.gtag) return;
 window.dataLayer = window.dataLayer || [];
 window.gtag = function () {window.dataLayer!.push(arguments);};
 window.gtag('js', new Date());
 // GA4 owns page_view events, including history changes when enhanced
 // measurement is enabled. Do not also send manual page_view events.
 window.gtag('config', measurementId);
 const script = document.createElement('script');
 script.async = true;
 script.src = `https://www.googletagmanager.com/gtag/js?id=${measurementId}`;
 document.head.append(script);
}

export function trackEvent(name: string, parameters: Record<string, string> = {}) {
 if (typeof window === 'undefined' || location.hostname !== 'mobx.vyuh.tech') return;
 window.gtag?.('event', name, {page_path: location.pathname, ...parameters});
}
