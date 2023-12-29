import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../models/companyModel.dart';
import '../../models/companyRepository.dart';


part 'company_event.dart';
part 'company_state.dart';

class CompanyBloc extends Bloc<CompanyEvent, CompanyState> {
  final CompanyRepository companyRepository = CompanyRepository();

  CompanyBloc() : super(CompanyInitial());

  @override
  Stream<CompanyState> mapEventToState(
      CompanyEvent event,
      ) async* {
    if (event is FetchCompanies) {
      yield CompanyLoading();
      try {
        final List<Company> companies =
        await companyRepository.getAllActiveCompanies();
        yield CompanyLoaded(companies);
      } catch (e) {
        yield CompanyError(e.toString());
      }
    }
  }
}
