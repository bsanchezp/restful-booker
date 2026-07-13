Feature: Actualizar usuario

  Como administrador del sistema
  Quiero poder actualizar la informacion de un usuario existente
  Para mantener la base de datos de usuarios al dia

  Background:
    * url baseUrl
    * def datosHelper = read('classpath:helpers/usuario-data.js')
    * def schemaMensaje = read('classpath:schemas/schema-mensagem.json')

  @positivo
  Scenario: Actualizar la informacion de un usuario existente
    * def usuarioNuevo = datosHelper()
    Given path 'usuarios'
    And request usuarioNuevo
    When method POST
    Then status 201
    * def idCreado = response._id

    * def usuarioActualizado = datosHelper()
    Given path 'usuarios', idCreado
    And request usuarioActualizado
    When method PUT
    Then status 200
    And match response == schemaMensaje
    And match response.message == 'Registro alterado com sucesso'

    # Se verifica que los datos realmente hayan cambiado
    Given path 'usuarios', idCreado
    When method GET
    Then status 200
    And match response.nome == usuarioActualizado.nome
    And match response.email == usuarioActualizado.email

  # Nota: la API de ServeRest permite hacer PUT sobre un ID inexistente y en ese caso
  # crea el registro (puede devolver 200 o 201 segun la version del servicio).
  # Se deja documentado como caso especial a validar contra el ambiente real.
  @negativo
  Scenario: Actualizar un usuario con un ID inexistente crea un nuevo registro
    * def usuarioNuevo = datosHelper()
    Given path 'usuarios', 'idQueNoExiste987654'
    And request usuarioNuevo
    When method PUT
    Then match responseStatus == '#? _ == 200 || _ == 201'
    And match response.message == '#string'
