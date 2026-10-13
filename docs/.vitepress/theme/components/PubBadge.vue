<script setup lang="ts">
defineProps<{name:string}>();
</script>
<template>
  <a :href="`https://pub.dev/packages/${name}`" class="pub-badge" :aria-label="`${name} on pub.dev`">
    <img :src="`https://img.shields.io/pub/v/${encodeURIComponent(name)}?label=${encodeURIComponent(name)}&style=flat-square&color=1974c7`" :alt="`${name} on pub.dev`" height="20" />
  </a>
</template>
