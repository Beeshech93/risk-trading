// Configuración pública de Supabase. La anon/publishable key puede estar en el navegador;
// la seguridad real la aplican Auth y las políticas RLS de la base de datos.
// Sustituye ambos valores por Project URL y anon/publishable key de tu proyecto Supabase.
export const SUPABASE_URL = 'https://YOUR_PROJECT.supabase.co';
export const SUPABASE_ANON_KEY = 'YOUR_SUPABASE_PUBLISHABLE_OR_ANON_KEY';
export const SUPABASE_CONFIGURED = !SUPABASE_URL.includes('YOUR_PROJECT') && !SUPABASE_ANON_KEY.includes('YOUR_SUPABASE');
