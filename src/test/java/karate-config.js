function fn() {
  var env = karate.env;
  if (!env) {
    env = 'dev';
  }
  karate.log('Ejecutando pruebas en el ambiente:', env);

  var config = {
    baseUrl: 'https://serverest.dev'
  };

  // Se pueden agregar variaciones de URL por ambiente si en el futuro
  // se dispone de un servidor de staging o mock propio.
  if (env === 'qa') {
    config.baseUrl = 'https://serverest.dev';
  }

  karate.configure('connectTimeout', 15000);
  karate.configure('readTimeout', 15000);

  return config;
}
