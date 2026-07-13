Feature: Flujo end-to-end CRUD de usuarios

  Como administrador del sistema
  Quiero poder crear, consultar, actualizar y eliminar un usuario en un solo flujo
  Para validar que el ciclo de vida completo del recurso funciona correctamente

  Background:
    * url baseUrl
    * def datosHelper = read('classpath:helpers/usuario-data.js')

  @e2e @positivo
  Scenario: Ciclo completo de gestion de un usuario (crear, buscar, actualizar, eliminar)

    # 1. Crear usuario
    * def usuarioNuevo = datosHelper()
    Given path 'usuarios'
    And request usuarioNuevo
    When method POST
    Then status 201
    * def idCreado = response._id

    # 2. Verificar que aparece en el listado filtrando por nombre
    Given path 'usuarios'
    And param nome = usuarioNuevo.nome
    When method GET
    Then status 200
    And match response.usuarios[*]._id contains idCreado

    # 3. Buscar el usuario por ID
    Given path 'usuarios', idCreado
    When method GET
    Then status 200
    And match response.nome == usuarioNuevo.nome

    # 4. Actualizar el usuario
    * def usuarioActualizado = datosHelper()
    Given path 'usuarios', idCreado
    And request usuarioActualizado
    When method PUT
    Then status 200
    And match response.message == 'Registro alterado com sucesso'

    # 5. Confirmar que la actualizacion se aplico
    Given path 'usuarios', idCreado
    When method GET
    Then status 200
    And match response.email == usuarioActualizado.email

    # 6. Eliminar el usuario
    Given path 'usuarios', idCreado
    When method DELETE
    Then status 200
    And match response.message == 'Registro excluído com sucesso'

    # 7. Confirmar que ya no existe
    Given path 'usuarios', idCreado
    When method GET
    Then status 400
    And match response.message == 'Usuário não encontrado'
