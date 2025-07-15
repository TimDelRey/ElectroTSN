import jquery from "jquery"
window.$ = jquery
window.jQuery = jquery

// в будущем нужно сделать настройки темы в одном файле с добавлением класса, затем его просто переключать
document.addEventListener('turbo:load', function() {
  const button = $('#theme-button');
  const dayStyle = $('#style-day')[0];
  const nightStyle = $('#style-night')[0];

  button.off ('click').on ('click', function() {
    const isDay = nightStyle.disabled;
    
    if (isDay) {
      dayStyle.disabled = true;
      nightStyle.disabled = false;
    } else {
      dayStyle.disabled = false;
      nightStyle.disabled = true;
    }
    
    button.text(isDay ? 'Светлая тема' : 'Темная тема');
  })
})
