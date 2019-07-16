global class WEXBreezeDebugLogging {

    global class debug implements BREeze.processRules.customDebug {

        public string pad = '[BREeze][DEBUG] ';

        public void info(string debugString) {

            System.debug(pad + debugString);

        }

    }

}