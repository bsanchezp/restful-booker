package runners;

import com.intuit.karate.junit5.Karate;

/**
 * Runner general del proyecto. Ejecuta toda la suite de pruebas,
 * excluyendo escenarios marcados explicitamente con @ignore.
 */
class AllFeaturesRunner {

    @Karate.Test
    Karate testAll() {
        return Karate.run("classpath:usuarios").tags("~@ignore");
    }
}
