import jquery from "jquery"
window.$ = jquery
window.jQuery = jquery

// в будущем нужно сделать настройки темы в одном файле с добавлением класса, затем его просто переключать
document.addEventListener('turbo:load', function() {
  const button = $('#theme-button');
  const dayStyle = $('#style-day')[0];
  const nightStyle = $('#style-night')[0];

  let themeNow = localStorage.getItem('theme');

  function applyTheme(themeNow) {
    if (themeNow === 'day') {
      dayStyle.disabled = false;
      nightStyle.disabled = true;
      button.text('Темная тема');
    } else {
      dayStyle.disabled = true;
      nightStyle.disabled = false;
      button.text('Светлая тема');
    }
  }

  applyTheme(themeNow);

  button.off ('click').on ('click', function() {
    themeNow = themeNow === 'day' ? 'night' : 'day';
    localStorage.setItem('theme', themeNow);
    applyTheme(themeNow);
  })
})
