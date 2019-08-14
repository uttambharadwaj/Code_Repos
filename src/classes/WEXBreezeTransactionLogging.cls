global class WEXBreezeTransactionLogging {

    global class debug implements BREeze.processRules.customDebug {

        public string pad = '[BREeze][TRANSACTION] ';

        public void info(string debugString) {

            System.debug(pad + debugString);

        }

    }

}