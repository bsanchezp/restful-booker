/**
 * Helper para generar datos de un usuario nuevo en cada ejecucion.
 */
function fn() {
  var uuid = java.util.UUID.randomUUID().toString().substring(0, 8);

  var datos = {
    nome: 'Usuario Prueba ' + uuid,
    email: 'usuario.' + uuid + '@teste.com',
    password: 'Senha@123',
    administrador: 'true'
  };

  return datos;
}
