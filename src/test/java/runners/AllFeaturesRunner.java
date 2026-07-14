package runners;

import com.intuit.karate.junit5.Karate;

class AllFeaturesRunner {

    @Karate.Test
    Karate testAll() {
        return Karate.run("classpath:usuarios").tags("~@ignore");
    }
}
