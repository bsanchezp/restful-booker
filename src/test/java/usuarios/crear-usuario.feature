Feature: Registrar usuario

  Como administrador del sistema
  Quiero poder registrar un nuevo usuario
  Para agregarlo a la base de datos de usuarios

  Background:
    * url baseUrl
    * def datosHelper = read('classpath:helpers/usuario-data.js')
    * def schemaCreacion = read('classpath:schemas/schema-criar-usuario.json')

  @positivo
  Scenario: Registrar un nuevo usuario con datos validos
    * def usuarioNuevo = datosHelper()
    Given path 'usuarios'
    And request usuarioNuevo
    When method POST
    Then status 201
    And match response == schemaCreacion
    And match response.message == 'Cadastro realizado com sucesso'
    And match response._id == '#string'

  @negativo
  Scenario: No permitir registrar un usuario con un email ya utilizado
    * def usuarioNuevo = datosHelper()

    Given path 'usuarios'
    And request usuarioNuevo
    When method POST
    Then status 201

    # Se intenta registrar nuevamente el mismo email
    Given path 'usuarios'
    And request usuarioNuevo
    When method POST
    Then status 400
    And match response.message == 'Este email já está sendo usado'

  @negativo
  Scenario Outline: No permitir registrar un usuario con campos obligatorios faltantes
    * def usuarioIncompleto = <usuario>
    Given path 'usuarios'
    And request usuarioIncompleto
    When method POST
    Then status 400

    Examples:
      | usuario |
      | { "email": "sinnombre@teste.com", "password": "Senha@123", "administrador": "true" } |
      | { "nome": "Usuario Sin Email", "password": "Senha@123", "administrador": "true" } |
      | { "nome": "Usuario Sin Password", "email": "sinpassword@teste.com", "administrador": "true" } |
      | { "nome": "Usuario Sin Administrador", "email": "sinadmin@teste.com", "password": "Senha@123" } |
