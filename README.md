
# Nuvei SDK Flutter
SDK para la integración de pagos Nuvei en aplicaciones Flutter.

Permite listar y eliminar tarjetas, realizar pagos débito, reembolsos y agregar tarjetas mediante un formulario UI integrado.


### 📦 Instalación
Agrega el SDK a tu proyecto Flutter desde GitHub:
```yaml
dependencies:
  nuvei_sdk_flutter:
    git:
      url: https://github.com/
```
Luego ejecuta:

```cmd
flutter pub get
```

### ⚙️ Inicialización del SDK
⚠️ Obligatorio: el SDK debe inicializarse antes de usar cualquier servicio.
```code
import 'package:nuvei_sdk_flutter/nuvei_sdk_flutter.dart';

final NuveiSdkFlutter nuvei = NuveiSdkFlutter();

nuvei.initEnvironment(
  Constants.appCode,
  Constants.appKey,
  Constants.serverCode,
  Constants.serverKey,
  true, // testMode
  Constants.clientId,
  Constants.clientSecret,
);

```
Si el SDK no está inicializado, los métodos retornarán error.


## 💳 Servicios disponibles

### 📋 Listar tarjetas
Obtiene las tarjetas asociadas a un usuario.
```code
final response = await NuveiSdkFlutter().listCards(
  userId: Constants.userId,
);
```
#### Parámetros

| Nombre |  Tipo | Requerido  |
|--------|-------|------------| 
| userId | String | ✅.        | 

Respuesta

```code
GeneralResponse
```

### ❌ Eliminar tarjeta
Elimina una tarjeta registrada.
```code
final response = await NuveiSdkFlutter().deleteCard(
  userId: Constants.userId,
  tokenCard: tokenCard,
);
```
Parámetros

|Nombre|Tipo|Requerido|
|------|-----|---|
|userId|String|✅|
|tokenCard |String|✅|


### 💰 Pago débito
Realiza un pago con una tarjeta previamente registrada.
```code
final response = await NuveiSdkFlutter().debit(
  userInformation: User(
    id: Constants.userId,
    email: "email@gmail.com",
  ),
  ordeInformation: Order(
    amount: 88.9,
    description: "breakfast",
    devReference: "reference",
    vat: 0,
    taxableAmount: 0,
    taxPercentage: 0,
  ),
  cardInformation: CardModel(
    token: cardModel?.token ?? '',
  ),
);
```

#### Ejemplo completo
```
final response = await NuveiSdkFlutter().debit(
  userInformation: User(
    id: Constants.userId,
    email: "email@gmail.com",
  ),
  ordeInformation: Order(
    amount: 88.9,
    description: "breakfast",
    devReference: "reference",
    vat: 0,
    taxableAmount: 0,
    taxPercentage: 0,
  ),
  cardInformation: CardModel(
    token: cardModel?.token ?? '',
  ),
);

Navigator.pop(context);

if (!response.error) {
  TransactionResponse payment =
      transactionResponseFromJson(jsonEncode(response.data));

  Navigator.pushNamed(
    context,
    'payment_detail',
    arguments: payment,
  );
}

```
### 🔁 Reembolso
Permite realizar el reembolso de una transacción.
```code
final response = await NuveiSdkFlutter().refund(
  transaction: transactionModel,
  order: order,
  moreInfo: true,
);
```
Parámetros

|Nombre |Tipo|Requerido|
|-------|----|---------|
|transaction| TransactionModel|✅|
|order|Order|❌|
|moreInfo|bool|❌|


### 🧩 Componente UI: FormAddCardWidget
Widget UI que debe implementar el desarrollador integrador para permitir el registro de tarjetas.
Este componente maneja:
- Formulario de tarjeta
- Validaciones
- Comunicación con Nuvei
- Estados de carga
- anejo de errores y éxito
#### 📌 Uso básico
```code
FormAddCardWidget(
  email: 'erick.guillen@nuvei.com',
  userId: '4',

  onLoading: (value) {
    if (value) {
      showDialog(
        context: context,
        builder: (context) =>
            const Center(child: CircularProgressIndicator()),
      );
    } else {
      Navigator.pop(context);
    }
  },

  onErrorProcess: (error) {
    showDialog(
      context: context,
      builder: (context) => Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Card(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      error.error.description,
                      style: const TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: FilledButtonWidget(
                        text: "Close",
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  },

  onSuccesProcess: (valid, message) {
    showDialog(
      context: context,
      builder: (context) => Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Card(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      message,
                      style: const TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: FilledButtonWidget(
                        text: "Close",
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  },
)
```

🧾 Props del FormAddCardWidget
| Prop              | Tipo            | Requerido | Descripción              |
|-------------------|-----------------|-----------|--------------------------|
| email             | String          | ✅        | Email del usuario        |
| userId            | String          | ✅        | Identificador del usuario|
| onLoading         | Function(bool)  | ✅        | Estado de carga          |
| onErrorProcess    | Function        | ✅        | Error del proceso        |
| onSuccesProcess   | Function(bool, String) | ✅ | Proceso exitoso          |


Resultado exitoso


#### 🔄 Flujo del formulario

1. El usuario ingresa los datos de la tarjeta


2. Se activa onLoading(true)


3. Se procesa el registro

Error → onErrorProcess

Éxito → onSuccesProcess
Finaliza con onLoading(false)



### ⚠️ Manejo de errores
Todos los servicios retornan un GeneralResponse:
```code
class GeneralResponse {
  final bool error;
  final dynamic data;
  final String? message;
}
Ejemplo:
if (response.error) {
  print(response.message);
}

```
