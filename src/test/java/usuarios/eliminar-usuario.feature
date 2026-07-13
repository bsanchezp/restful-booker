Feature: Eliminar usuario

  Como administrador del sistema
  Quiero poder eliminar un usuario del sistema
  Para depurar la base de datos de usuarios

  Background:
    * url baseUrl
    * def datosHelper = read('classpath:helpers/usuario-data.js')
    * def schemaMensaje = read('classpath:schemas/schema-mensagem.json')

  @positivo
  Scenario: Eliminar un usuario existente
    * def usuarioNuevo = datosHelper()
    Given path 'usuarios'
    And request usuarioNuevo
    When method POST
    Then status 201
    * def idCreado = response._id

    Given path 'usuarios', idCreado
    When method DELETE
    Then status 200
    And match response == schemaMensaje
    And match response.message == 'Registro excluído com sucesso'

    # Se confirma que el usuario ya no puede ser encontrado
    Given path 'usuarios', idCreado
    When method GET
    Then status 400
    And match response.message == 'Usuário não encontrado'

  @negativo
  Scenario: Eliminar un usuario con un ID inexistente no produce error
    Given path 'usuarios', 'idQueNoExiste112233'
    When method DELETE
    Then status 200
    And match response.message == 'Nenhum registro excluído'
