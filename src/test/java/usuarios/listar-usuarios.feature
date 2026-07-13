Feature: Listar usuarios

  Como administrador del sistema
  Quiero poder obtener la lista de usuarios registrados
  Para verificar el estado de la base de datos de usuarios

  Background:
    * url baseUrl
    * def schemaListado = read('classpath:schemas/schema-listar-usuarios.json')

  @positivo
  Scenario: Obtener la lista completa de usuarios exitosamente
    Given path 'usuarios'
    When method GET
    Then status 200
    And match response == schemaListado
    And match response.quantidade == '#number'
    And match response.usuarios == '#array'

  @positivo
  Scenario: Filtrar usuarios por nombre mediante query param
    * def datosHelper = read('classpath:helpers/usuario-data.js')
    * def usuarioNuevo = datosHelper()

    # Se crea un usuario conocido para asegurar que el filtro tenga al menos un resultado
    Given path 'usuarios'
    And request usuarioNuevo
    When method POST
    Then status 201

    Given path 'usuarios'
    And param nome = usuarioNuevo.nome
    When method GET
    Then status 200
    And match response.usuarios[0].nome == usuarioNuevo.nome

  @negativo
  Scenario: Filtrar por un nombre que no existe devuelve lista vacia
    Given path 'usuarios'
    And param nome = 'NombreQueSeguramenteNoExiste_zzz'
    When method GET
    Then status 200
    And match response.quantidade == 0
    And match response.usuarios == '#[0]'
