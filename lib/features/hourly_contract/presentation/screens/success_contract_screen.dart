import 'package:exp_intern/core/utils/routes_manager.dart';
import 'package:exp_intern/core/widgets/custom_elevated_button.dart';
import 'package:exp_intern/features/dynamic_steps/domain/entity/dynamic_step_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:exp_intern/core/utils/colors_manager.dart';
import 'package:flutter_hyperpay/flutter_hyperpay.dart'; // 💡 استيراد البلجن
import '../../../../core/payment/in_app_payment.dart';
import '../../../../core/utils/locale_keys.g.dart';
import '../../../../core/utils/request_status_enum.dart';
import '../../../payment/presentation/cubit/payment_cubit.dart';
import '../../../payment/presentation/cubit/payment_state.dart';
import '../cubit/hourly_contract_cubit.dart';
import '../cubit/hourly_contract_state.dart';
import '../widgets/contract_info_card.dart';
import '../widgets/payment_alert_card.dart';
import '../widgets/success_icon_widget.dart';

class SuccessContractScreen extends StatefulWidget {
  final DynamicStepEntity? stepEntity;

  const SuccessContractScreen({
    super.key,
    this.stepEntity,
  });

  @override
  State<SuccessContractScreen> createState() => _SuccessContractScreenState();
}

class _SuccessContractScreenState extends State<SuccessContractScreen> {
  int? _selectedMethodIndex;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HourlyContractCubit>().fetchContractSuccessData(
        stepId: widget.stepEntity?.stepId ?? '',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: isDarkMode ? ColorsManager.black : ColorsManager.white,
      appBar: _buildAppBar(isDarkMode, textTheme, context),
      body: SafeArea(
        child: MultiBlocListener(
          listeners: [
            BlocListener<HourlyContractCubit, HourlyContractState>(
              listenWhen: (previous, current) =>
              previous.contractSuccessData.status != current.contractSuccessData.status,
              listener: (context, state) {
                if (state.contractSuccessData.status == RequestStatus.success &&
                    state.contractSuccessData.data.isNotEmpty) {
                  final contractInfo = state.contractSuccessData.data.first;

                  final String paymentId = contractInfo.id ?? '';
                  context.read<PaymentCubit>().fetchShopperResult(
                    id: paymentId,
                    type: 1,
                  );
                }
              },
            ),

            BlocListener<PaymentCubit, PaymentState>(
              listenWhen: (previous, current) =>
              previous.isCheckOutLoading != current.isCheckOutLoading ||
                  previous.isCheckOutSuccess != current.isCheckOutSuccess ||
                  previous.isCheckOutError != current.isCheckOutError,
              listener: (context, state) async { // تم تحويل الـ listener لـ async
                if (state.isCheckOutLoading) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => const Center(
                      child: CircularProgressIndicator(color: ColorsManager.primaryTeal),
                    ),
                  );
                } else {
                  if (state.isCheckOutSuccess || state.isCheckOutError) {
                    Navigator.of(context, rootNavigator: true).pop();
                  }
                }

                if (state.isCheckOutSuccess) {
                  final String checkOutId = state.checkOutId ?? '';
                  final shopperCubit = context.read<PaymentCubit>();
                  final paymentMethods = shopperCubit.state.shopperResultEntity?.paymentMethods;

                  if (_selectedMethodIndex != null && paymentMethods != null) {
                    final selectedBrandName = paymentMethods[_selectedMethodIndex!].brandName ?? '';

                    try {
                      final hyperpay = FlutterHyperpay(
                        channeleName: InAppPaymentSetting.channel,
                        shopperResultUrl: InAppPaymentSetting.ShopperResultUrl,
                        paymentMode: PaymentMode.TEST,
                        lang: InAppPaymentSetting.getLang(),
                      );

                      await hyperpay.readyUICards(
                        readyUI: ReadyUI(
                          brandName: selectedBrandName,
                          checkoutid: checkOutId,
                          setStorePaymentDetailsMode: true,
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("خطأ أثناء فتح بوابة الدفع: $e"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                }

                if (state.isCheckOutError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.checkOutFailure?.message ?? 'فشلت عملية تهيئة الدفع'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
          child: BlocBuilder<HourlyContractCubit, HourlyContractState>(
            builder: (context, contractState) {
              if (contractState.contractSuccessData.status == RequestStatus.loading) {
                return const Center(
                  child: CircularProgressIndicator(color: ColorsManager.primaryTeal),
                );
              }

              if (contractState.contractSuccessData.status == RequestStatus.error) {
                return Center(
                  child: Text(
                    contractState.contractSuccessData.error ?? 'حدث خطأ ما',
                    style: TextStyle(color: Colors.red, fontSize: 16.sp),
                  ),
                );
              }

              if (contractState.contractSuccessData.status == RequestStatus.success &&
                  contractState.contractSuccessData.data.isNotEmpty) {
                final contractInfo = contractState.contractSuccessData.data.first;

                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                  child: Column(
                    children: [
                      SizedBox(height: 10.h),
                      const SuccessIconWidget(),
                      SizedBox(height: 15.h),
                      Center(
                        child: Text(
                          LocaleKeys.contract_registered_successfully.tr(),
                          textAlign: TextAlign.center,
                          style: textTheme.displayLarge?.copyWith(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? ColorsManager.white : ColorsManager.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),

                      ContractInfoCard(
                        isDarkMode: isDarkMode,
                        contractNumber: contractInfo.contractNo ?? '',
                        contractValue: contractInfo.finalPrice ?? '0',
                      ),

                      SizedBox(height: 20.h),

                      BlocBuilder<PaymentCubit, PaymentState>(
                        builder: (context, paymentState) {
                          if (paymentState.isShopperResultLoading) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(color: ColorsManager.primaryTeal),
                              ),
                            );
                          }

                          if (paymentState.isShopperResultError) {
                            return Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text(
                                    paymentState.shopperResultFailure?.message ?? 'فشل تحميل طرق الدفع',
                                    style: TextStyle(color: Colors.red, fontSize: 14.sp),
                                  ),
                                ),
                                SizedBox(height: 20.h),
                                _buildHomeButton(context),
                              ],
                            );
                          }

                          if (paymentState.isShopperResultSuccess &&
                              paymentState.shopperResultEntity != null) {
                            final shopperData = paymentState.shopperResultEntity!;
                            final String amountToPay = shopperData.paymentCredentials?.finalPrice?.toString() ??
                                contractInfo.finalPrice ?? '0';

                            final hasSelectedMethod = _selectedMethodIndex != null;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (contractInfo.paymentNote != null && contractInfo.paymentNote!.isNotEmpty)
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 20.h),
                                    child: PaymentAlertCard(
                                      text: contractInfo.paymentNote!,
                                      isDarkMode: isDarkMode,
                                      amountToPay: amountToPay,
                                    ),
                                  ),

                                Text(
                                  "اختر طريقة الدفع المناسبة:",
                                  style: textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp,
                                    color: isDarkMode ? ColorsManager.white : ColorsManager.black,
                                  ),
                                ),
                                SizedBox(height: 12.h),

                                shopperData.paymentMethods != null && shopperData.paymentMethods!.isNotEmpty
                                    ? GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 10.w,
                                    mainAxisSpacing: 10.h,
                                    mainAxisExtent: 85.h,
                                  ),
                                  itemCount: shopperData.paymentMethods!.length,
                                  itemBuilder: (context, index) {
                                    final method = shopperData.paymentMethods![index];
                                    final isSelected = _selectedMethodIndex == index;

                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          _selectedMethodIndex = index;
                                        });
                                      },
                                      borderRadius: BorderRadius.circular(12.r),
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? ColorsManager.primaryTeal.withOpacity(0.1)
                                              : (isDarkMode ? Colors.grey[900] : Colors.grey[100]),
                                          borderRadius: BorderRadius.circular(12.r),
                                          border: Border.all(
                                            color: isSelected
                                                ? ColorsManager.primaryTeal
                                                : ColorsManager.primaryTeal.withOpacity(0.15),
                                            width: isSelected ? 2.w : 1.w,
                                          ),
                                          boxShadow: isSelected
                                              ? [
                                            BoxShadow(
                                              color: ColorsManager.primaryTeal.withOpacity(0.2),
                                              blurRadius: 6,
                                              offset: const Offset(0, 3),
                                            )
                                          ]
                                              : null,
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Image.network(
                                                isDarkMode
                                                    ? (method.imageDark ?? method.imageUrl ?? '')
                                                    : (method.imageUrl ?? ''),
                                                fit: BoxFit.contain,
                                                errorBuilder: (context, error, stackTrace) =>
                                                const Icon(Icons.payment, color: ColorsManager.primaryTeal),
                                              ),
                                            ),
                                            SizedBox(height: 6.h),
                                            Text(
                                              method.brandName ?? '',
                                              textAlign: TextAlign.center,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: textTheme.bodySmall?.copyWith(
                                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                                fontSize: 11.sp,
                                                color: isSelected
                                                    ? ColorsManager.primaryTeal
                                                    : (isDarkMode ? ColorsManager.white : ColorsManager.black),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                )
                                    : const SizedBox.shrink(),

                                SizedBox(height: 32.h),

                                IgnorePointer(
                                  ignoring: !hasSelectedMethod,
                                  child: Opacity(
                                    opacity: hasSelectedMethod ? 1.0 : 0.5,
                                    child: Padding(
                                      padding: REdgeInsets.symmetric(horizontal: 16.0),
                                      child: CustomElevatedButton(
                                        text: "ادفع $amountToPay لتفعيل العقد",
                                        onPressed: () {
                                          if (hasSelectedMethod) {
                                            final selectedMethod = shopperData.paymentMethods![_selectedMethodIndex!];

                                            context.read<PaymentCubit>().generateCheckOutId(
                                              id: contractInfo.id ?? '',
                                              type: 1,
                                              cardBrand: selectedMethod.brandName ?? '',
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(height: 12.h),

                                _buildHomeButton(context),
                              ],
                            );
                          }

                          return Padding(
                            padding: EdgeInsets.only(top: 32.h),
                            child: _buildHomeButton(context),
                          );
                        },
                      ),
                    ],
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHomeButton(BuildContext context) {
    return Padding(
      padding: REdgeInsets.symmetric(horizontal: 16.0),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          minimumSize: Size(double.infinity, 50.h),
          side: const BorderSide(color: ColorsManager.primaryTeal),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        onPressed: () {
          Navigator.pushNamed(context, RoutesManager.home);
        },
        child: Text(
          LocaleKeys.home.tr(),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: ColorsManager.primaryTeal,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(bool isDarkMode, TextTheme textTheme, BuildContext context) {
    return AppBar(
      backgroundColor: isDarkMode ? ColorsManager.black : ColorsManager.white,
      elevation: 0,
      centerTitle: true,
      title: Text(
        LocaleKeys.contract_success.tr(),
        style: textTheme.displayLarge?.copyWith(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: isDarkMode ? ColorsManager.white : ColorsManager.black,
        ),
      ),
    );
  }
}