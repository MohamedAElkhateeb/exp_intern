import 'package:exp_intern/core/utils/routes_manager.dart';
import 'package:exp_intern/core/widgets/custom_elevated_button.dart';
import 'package:exp_intern/features/dynamic_steps/domain/entity/dynamic_step_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:exp_intern/core/utils/colors_manager.dart';
import '../../../../core/utils/locale_keys.g.dart';
import '../../../../core/utils/request_status_enum.dart';
import '../cubit/hourly_contract_cubit.dart';
import '../cubit/hourly_contract_state.dart';
import '../widgets/contract_info_card.dart';
import '../widgets/payment_alert_card.dart';
import '../widgets/success_icon_widget.dart';
import '../widgets/wallet_balance_card.dart';

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
      backgroundColor: ColorsManager.white,
      appBar: _buildAppBar(isDarkMode, textTheme, context),
      body: SafeArea(
        child: BlocBuilder<HourlyContractCubit, HourlyContractState>(
          builder: (context, state) {
            if (state.contractSuccessData.status == RequestStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(color: ColorsManager.primaryTeal),
              );
            }

            if (state.contractSuccessData.status == RequestStatus.error) {
              return Center(
                child: Text(
                  state.contractSuccessData.error ?? 'حدث خطأ ما',
                  style: TextStyle(color: Colors.red, fontSize: 16.sp),
                ),
              );
            }

            if (state.contractSuccessData.status == RequestStatus.success &&
                state.contractSuccessData.data.isNotEmpty) {

              final contractInfo = state.contractSuccessData.data.first;

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 40.h),
                child: Column(
                  children: [
                    SizedBox(height: 30.h),
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

                    SizedBox(height: 24.h),

                    // WalletBalanceCard(
                    //   isDarkMode: isDarkMode,
                    //   walletBalance: contractInfo.,
                    //   usableBalance: contractInfo,
                    // ),

                    SizedBox(height: 24.h),

                    PaymentAlertCard(
                      text:contractInfo.paymentNote??'' ,
                      isDarkMode: isDarkMode,
                      amountToPay: contractInfo.finalPrice ?? '0',
                    ),

                    SizedBox(height: 32.h),
                    Padding(
                      padding:  REdgeInsets.all(16.0),
                      child: CustomElevatedButton(text: LocaleKeys.home.tr(), onPressed: () {
                        Navigator.pushNamed(context, RoutesManager.home);
                      },),
                    )
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar(bool isDarkMode, TextTheme textTheme, BuildContext context) {
    return AppBar(
      backgroundColor: ColorsManager.white,
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