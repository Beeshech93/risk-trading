# Risk Trading: activar autenticación

El código de acceso y el guard del dashboard ya están añadidos, pero **el login no funcionará hasta conectar un proyecto Supabase real**. No compartas contraseñas ni claves secretas.

## 1. Crear/configurar Supabase

1. Crea un proyecto en https://supabase.com/dashboard.
2. En **Authentication → Providers → Email**, habilita Email.
3. Decide si quieres exigir confirmación de correo. Si la confirmación está habilitada, añade la URL de tu app a las URL de redirección permitidas.
4. En **Authentication → URL Configuration**, configura:
   - Site URL: `https://risk.lajanrapid.app`
   - Redirect URLs: `https://risk.lajanrapid.app/**` y, para pruebas, la URL `*.pages.dev` exacta de tu proyecto.
5. En **Project Settings → API** (o Connect), copia Project URL y la clave pública **anon/publishable**. Nunca uses `service_role` en el navegador.

## 2. Conectar el frontend

Edita `js/config.js` en GitHub y sustituye:
- `https://YOUR_PROJECT.supabase.co` por la Project URL real.
- `YOUR_SUPABASE_PUBLISHABLE_OR_ANON_KEY` por la clave pública anon/publishable.

Guarda el commit. La clave pública puede estar en frontend solo porque la tabla está protegida por RLS; no pongas claves secretas ni una OpenAI API key aquí.

## 3. Crear la tabla privada de datos

En Supabase abre **SQL Editor → New query**, copia el contenido completo de `supabase/schema.sql` de este repositorio y ejecuta el script. Crea una fila por usuario y habilita Row Level Security para que solo el propietario autenticado pueda leer, crear, actualizar o borrar su fila.

## 4. Cloudflare Pages

- En **Workers & Pages → tu proyecto → Settings → Builds & deployments**, confirma que el repositorio conectado sea `Beeshech93/risk-trading` y la rama de producción sea `main`.
- Como el proyecto es HTML/JS estático, no requiere build command; el directorio de salida es la raíz del repositorio (`/`).
- Añade el dominio personalizado `risk.lajanrapid.app` en **Custom domains** si todavía no está conectado.
- Espera a que termine el despliegue del último commit.

## 5. Probar

1. Abre `https://risk.lajanrapid.app/login.html`.
2. Crea una cuenta de prueba y confirma el correo si Supabase lo solicita.
3. Inicia sesión; el dashboard debe abrirse en `/`.
4. Registra una operación, cierra sesión y entra con otra cuenta. La segunda cuenta no debe ver los datos de la primera.
5. Comprueba en Supabase **Table Editor → risk_trading_data** que se guardan filas con distintos `user_id`.

## Qué hace este cambio

- Añade `login.html` con inicio de sesión, registro público y recuperación de contraseña.
- Añade `js/auth.js` para Supabase Auth por correo y contraseña.
- Protege el dashboard principal: sin una sesión válida redirige a `/login.html`.
- Guarda el estado e historial en Supabase, separado por `user_id` y protegido por políticas RLS.
- `js/config.js` es una plantilla: debes rellenarla con los valores de tu proyecto para activar el servicio.

**Importante:** al activar el almacenamiento remoto, los datos existentes que solo estuvieran en el localStorage del navegador no se importan automáticamente a Supabase. Exporta el CSV anterior si necesitas conservarlo.
