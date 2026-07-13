/**
 * Helper para generar datos de un usuario nuevo en cada ejecucion.
 * Usa un identificador aleatorio para evitar colisiones de email
 * entre corridas de test (la API de ServeRest no permite emails duplicados).
 *
 * Nota: los nombres de los campos (nome, email, password, administrador)
 * respetan el contrato real de la API de ServeRest, que esta en portugues.
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
