import {ArrowDown,ArrowRight} from '@lucide/vue';
export function Arrow({down=false}:{down?:boolean}){const Icon=down?ArrowDown:ArrowRight;return <Icon class="link-arrow" size={20} stroke-width={1.7} aria-hidden="true"/>;}
