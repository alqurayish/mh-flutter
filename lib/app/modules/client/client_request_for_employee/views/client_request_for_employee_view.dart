import '../../../../common/utils/exports.dart';
import '../../../../common/widgets/custom_appbar.dart';
import '../../../../common/widgets/custom_bottombar.dart';
import '../controllers/client_request_for_employee_controller.dart';

class ClientRequestForEmployeeView extends GetView<ClientRequestForEmployeeController> {
  const ClientRequestForEmployeeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.context = context;

    return Scaffold(
      appBar: CustomAppbar.appbar(
        title: "Request Employee",
        context: context,
      ),
      bottomNavigationBar: CustomBottomBar(
        child: CustomButtons.button(
          onTap: controller.onRequestPressed,
          text: "Request",
          customButtonStyle: CustomButtonStyle.radiusTopBottomCorner,
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        itemCount: controller.appController.allActivePositions.length,
        itemBuilder: (context, index) {
          return _positionItem(index);
        },
      ),
    );
  }

  Widget _positionItem(int index) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Obx(
                () => Container(
                  height: 15,
                  width: 15,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                        color: controller.selectedEmployee[index] > 0
                            ? Colors.green
                            : Colors.grey.withOpacity(.2),
                        border: Border.all(
                      color: Colors.grey.withOpacity(.3),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Text(controller.appController.allActivePositions[index].name!),

              const Spacer(),

              SizedBox(
                height: 40,
                width: 80,
                child: DropdownButtonFormField<int>(
                      value: controller.selectedEmployee[index],
                      icon: const Icon(Icons.arrow_drop_down),
                      isDense: true,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                      ),
                      onChanged: (int? newValue) {
                        controller.onDropdownChange(newValue!, index);
                      },
                      items: controller.dropdownValues.map<DropdownMenuItem<int>>((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(value.toString()),
                        );
                      }).toList(),
                    ),
              ),

                ],
          ),
        ),
        Container(
          height: 1,
          width: double.infinity,
          color: Colors.grey.withOpacity(.3),
        )
      ],
    ),
  );
}
