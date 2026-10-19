<script setup lang="ts">
import {computed} from 'vue';
import {useRoute} from 'vitepress';
const route=useRoute();
const english=computed(()=>route.path.replace(/^\/ko(?=\/|$)/,'')||'/');
</script>
<template>
 <div class="locale-not-found">
  <p class="code">404</p>
  <h1>페이지를 찾을 수 없습니다</h1>
  <p>아직 한국어로 번역되지 않은 페이지일 수 있습니다. 영어 원문을 확인해 보세요.</p>
  <div class="actions"><a :href="english" class="primary">영어 원문 보기</a><a href="/ko/">한국어 홈으로</a></div>
 </div>
</template>
<style>
.locale-not-found{padding:64px 24px 96px;text-align:center}
.locale-not-found .code{font-size:64px;font-weight:600;line-height:64px}
.locale-not-found h1{padding-top:12px;font-size:20px;font-weight:700;letter-spacing:2px}
.locale-not-found p:not(.code){margin:24px auto 0;max-width:420px;color:var(--vp-c-text-2)}
.locale-not-found .actions{display:flex;flex-wrap:wrap;justify-content:center;gap:12px;padding-top:24px}
.locale-not-found .actions a{padding:3px 16px;border:1px solid var(--vp-c-brand-1);border-radius:16px;font-size:14px;font-weight:500;color:var(--vp-c-brand-1)}
.locale-not-found .actions a.primary{background:var(--vp-c-brand-1);color:var(--vp-c-white)}
</style>
