Feature: Buscar usuario por ID

  Como administrador del sistema
  Quiero poder buscar un usuario especifico por su ID
  Para consultar su informacion de manera individual

  Background:
    * url baseUrl
    * def datosHelper = read('classpath:helpers/usuario-data.js')
    * def schemaUsuario = read('classpath:schemas/schema-usuario.json')
    * def schemaMensaje = read('classpath:schemas/schema-mensagem.json')

  @positivo
  Scenario: Buscar un usuario existente por su ID
    * def usuarioNuevo = datosHelper()
    Given path 'usuarios'
    And request usuarioNuevo
    When method POST
    Then status 201
    * def idCreado = response._id

    Given path 'usuarios', idCreado
    When method GET
    Then status 200
    And match response == schemaUsuario
    And match response._id == idCreado
    And match response.nome == usuarioNuevo.nome
    And match response.email == usuarioNuevo.email

  @negativo
  Scenario: Buscar un usuario con un ID que no existe
    Given path 'usuarios', 'idQueNoExiste123456'
    When method GET
    Then status 400
    And match response == schemaMensaje
    And match response.message == 'Usuário não encontrado'
