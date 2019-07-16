global class WEXBreezeInformationLogging {

    global class debug implements BREeze.processRules.customDebug {

        public string pad = '[BREeze][INFORMATION] ';

        public void info(string debugString) {

            System.debug(pad + debugString);

        }

    }

}