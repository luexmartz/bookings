# ---------------------------------- Prompt ----------------------------------
valida que los siguientes datos estén correctos según el orden definido, y que en efecto el dato represente una ciudad, un estado o un país

city, state, country

Ciudad de México, Distrito Federal, México
Monterrey, Nuevo León, México
Guadalajara, Jalisco, México
Morelia, Michoacán, México
Acapulco, Guerrero, México
Puerto Vallarta, Jalisco, México
Puerto Vallarta, Jalisco, México
León, Guanajuato, México
Tijuana, Baja California, México
Santiago de Querétaro, Querétaro, México
San Luis Potosí, San Luis Potosí, México
Mazatlán, Sinaloa, México
Guanajuato, Guanajuato, México
Puebla, Puebla, México
Aguascalientes, Aguascalientes, México
San Miguel de Allende, Guanajuato, México
Toluca, México, México

# ---------------------------------- Response ----------------------------------

Revisemos cada fila y validemos si el formato es correcto y si los datos representan efectivamente una **ciudad, estado y país**.

### **Errores detectados:**
1. **"Ciudad de México, Distrito Federal, México"** ❌
   - **Error:** "Distrito Federal" **ya no existe**.
   - **Corrección:** Debe ser **"Ciudad de México, Ciudad de México, México"**.

2. **"Toluca, México, México"** ✅⚠️
   - **Toluca** es la **capital del Estado de México**, por lo que es correcto.
   - Sin embargo, el **Estado de México** debería llamarse así completamente para evitar confusión con el país.
   - **Corrección sugerida:** "Toluca, Estado de México, México" (opcional, pero más claro).

### **Datos Correctos ✅**
✔ Monterrey, Nuevo León, México
✔ Guadalajara, Jalisco, México
✔ Morelia, Michoacán, México
✔ Acapulco, Guerrero, México
✔ Puerto Vallarta, Jalisco, México
✔ León, Guanajuato, México
✔ Tijuana, Baja California, México
✔ Santiago de Querétaro, Querétaro, México
✔ San Luis Potosí, San Luis Potosí, México
✔ Mazatlán, Sinaloa, México
✔ Guanajuato, Guanajuato, México
✔ Puebla, Puebla, México
✔ Aguascalientes, Aguascalientes, México
✔ San Miguel de Allende, Guanajuato, México

### **Corrección Final:**
| **City**                 | **State**              | **Country** |
|--------------------------|----------------------|------------|
| **Ciudad de México**      | **Ciudad de México**  | México     |
| Monterrey                | Nuevo León           | México     |
| Guadalajara              | Jalisco              | México     |
| Morelia                  | Michoacán            | México     |
| Acapulco                 | Guerrero             | México     |
| Puerto Vallarta          | Jalisco              | México     |
| León                     | Guanajuato           | México     |
| Tijuana                  | Baja California      | México     |
| Santiago de Querétaro    | Querétaro            | México     |
| San Luis Potosí          | San Luis Potosí      | México     |
| Mazatlán                 | Sinaloa              | México     |
| Guanajuato               | Guanajuato           | México     |
| Puebla                   | Puebla               | México     |
| Aguascalientes           | Aguascalientes       | México     |
| San Miguel de Allende    | Guanajuato           | México     |
| **Toluca**               | **Estado de México** | México     |

Así, todo estaría validado correctamente ✅.