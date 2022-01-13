import 'package:sheet_widget_demo/provider/provider_api.dart';
import 'package:sheet_widget_demo/provider/provider_api_page_demo.dart';
import 'package:sheet_widget_demo/provider/provider_response.dart';

class ProviderViewModel {
  ProviderApiDemoState providerApiDemoState;
  List<ProviderResponse> providerData;

  ProviderViewModel(this.providerApiDemoState) {
    if (providerData == null || providerData.length == 0) {
      providerApi();
    }
  }

  providerApi() async {
    List<ProviderResponse> data = await ProviderPageApi().providerApi();
    if (data != null) {
      print('Data --> ${data.length}');
      providerData = data;
      // ignore: invalid_use_of_protected_member
      providerApiDemoState.setState(() {});
    } else {
      print('Data null');
    }
  }
}
