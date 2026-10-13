<script setup lang="ts">
import {ref,computed} from 'vue';
import {ArrowRight,Hash,ShoppingBag,ListChecks,Boxes,CloudDownload,Radio,Zap,GitBranch} from '@lucide/vue';
import examples from '../data/gallery.json';
const selected=ref('All');
const levels=['All','Fundamentals','Collections','Async','Architecture'];
const icons=[Hash,ShoppingBag,ListChecks,Boxes,CloudDownload,Radio,Zap,GitBranch];
const visible=computed(()=>examples.filter(e=>selected.value==='All'||e.level===selected.value));
</script>
<template>
 <div class="gallery-filters" aria-label="Filter examples"><button v-for="level in levels" :key="level" :aria-pressed="selected===level" @click="selected=level">{{level}}</button></div>
 <div class="gallery-list"><a v-for="example in visible" :key="example.id" :href="'/gallery/'+example.id" class="gallery-example"><component :is="icons[examples.indexOf(example)]" :size="26" aria-hidden="true"/><div><h2>{{example.title}}</h2><p>{{example.concept}}</p></div><ArrowRight class="link-arrow" :size="22" aria-hidden="true"/></a></div>
</template>
<style>
.gallery-filters{display:flex;flex-wrap:wrap;gap:8px;margin:28px 0}
.gallery-filters button{padding:8px 14px;border-radius:7px;border:1px solid var(--vp-c-divider);cursor:pointer}
.gallery-filters button[aria-pressed=true]{background:#1974c7;color:white;border-color:#1974c7}
.gallery-list{border-top:1px solid var(--vp-c-divider)}
a.gallery-example{display:flex;align-items:center;gap:22px;padding:25px 4px;border-bottom:1px solid var(--vp-c-divider);text-decoration:none;color:var(--vp-c-text-1)}
.gallery-example>svg:first-child{color:var(--vp-c-brand-1);flex-shrink:0}.gallery-example>svg:last-child{margin-left:auto;flex-shrink:0}
.gallery-example h2{margin:0;padding:0;border:0;font-size:21px}.gallery-example p{margin:6px 0 0;color:var(--vp-c-text-2);font-size:14px}
.gallery-example:hover h2{color:var(--vp-c-brand-1)}
@media(max-width:600px){.gallery-example h2{font-size:18px}.gallery-example{gap:14px}}
</style>
