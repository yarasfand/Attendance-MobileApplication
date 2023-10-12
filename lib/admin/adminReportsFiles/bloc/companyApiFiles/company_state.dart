part of 'company_bloc.dart';

abstract class CompanyState {
  const CompanyState();
}

class CompanyInitial extends CompanyState {
  const CompanyInitial();
}

class CompanyLoading extends CompanyState {
  const CompanyLoading();
}

class CompanyLoaded extends CompanyState {
  final List<Company> companies;

  const CompanyLoaded(this.companies);
}

class CompanyError extends CompanyState {
  final String errorMessage;

  const CompanyError(this.errorMessage);
}
