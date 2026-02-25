import 'package:contact_directory/features/police_contacts/data/sources/police_contacts_remote_data_source.dart';
import 'package:get_it/get_it.dart';
import '../../../../app/flavours/app_config.dart';
import '../../../police_contacts/data/sources/police_contacts_local_data_source.dart';
import '../../../police_contacts/domain/repositories/police_contacts_repository.dart';
import '../../../police_contacts/domain/usecases/police_contacts_usecase.dart';
import 'api_client_config.dart';

final serviceLocator = GetIt.instance;

class ServiceLocator {
  late AppConfig _config;

  init({required AppConfig appConfig}) {
    _config = appConfig;

    // Base Register
    _baseRegister();

    // Register Repositories
    _registerRepositories();
  }

  void _baseRegister() {
    // Register AppConfig
    registerSingleton<AppConfig>(_config);

    registerFactory<ApiClientConfig>(
      () => ApiClientConfig(
        baseUrl: _config.apiBaseUrl,
        isDebug: _config.debug,
        apiVersion: _config.apiVersion,
      ),
    );

    
  }

  void _registerRepositories() {
    _registerRepoWithOutCache();
   _registerRepoWithCache();
  }

  void _registerRepoWithOutCache() {
    //registerFactory<ApiUrl>(() => ApiUrl());

    // registerFactory<SplashRepository>(
    //   () => SplashRepositoryImpl(get<ApiClient>()),
    // );

    _registerUseCase();
  }

   void _registerRepoWithCache() {
  //   _registerAuthRepositories(client, cache);
     _registerProcedureRepositories();
   }

  void _registerUseCase() {
    // registerFactory<SplashUseCase>(() => SplashUseCase(get<SplashRepository>()));

    // registerFactory<AuthUseCase>(() => AuthUseCase(get<AuthRepository>()));

    registerFactory<PoliceContactsUseCase>(() => PoliceContactsUseCase(get<PoliceContactsRepository>()));
  }

  // void _registerAuthRepositories(ApiClient client, BaseCache cache) {
  //   var authHttp = AuthHttpImpl(client, get<ApiUrl>());
  //   var authCache = AuthCacheImpl(cache, authHttp);
  //   registerSingleton<AuthRepository>(authCache);
  // }

  void _registerProcedureRepositories() {
    var procedureCache = PoliceContactsLocalDataSource();
    registerSingleton<PoliceContactsRepository>(procedureCache);
  }

  static registerSingleton<T extends Object>(object) {
    serviceLocator.registerSingleton<T>(object);
  }

  static registerFactory<T extends Object>(object) {
    serviceLocator.registerFactory<T>(object);
  }

  static T get<T extends Object>() {
    return serviceLocator.get<T>();
  }

  Future<void> restartServiceLocator() async {
    await serviceLocator.reset();
    // await dotenv.load();
    // _config.loadData(dotenv.env);
    init(appConfig: _config);
  }
}
