package runners;

import com.intuit.karate.junit5.Karate;

/**
 * Ejecuta todos los feature files ubicados en la carpeta "usuarios"
 * (listar, crear, buscar, actualizar, eliminar y el flujo end-to-end).
 */
class UsuariosRunner {

    @Karate.Test
    Karate testUsuarios() {
        return Karate.run("classpath:usuarios");
    }
}
