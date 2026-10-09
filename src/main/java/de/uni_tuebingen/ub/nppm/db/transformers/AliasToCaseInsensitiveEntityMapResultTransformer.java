package de.uni_tuebingen.ub.nppm.db.transformers;

import org.hibernate.transform.AliasedTupleSubsetResultTransformer;
import org.apache.commons.collections4.map.CaseInsensitiveMap;
import java.util.Map;

/*/
 * This transformer was implemented as a workaround
 * to allow case insensitivity within hibernate results.
 *
 * This is necessary because the original NeG (pre-NPPM) code was not exact about case sensitivity.
 * Since they used DB connections with result sets, accessing fields has been case insensitive.
 * (e.g. when trying to access the field personID instead of PersonID).
 *
 * Also, many times these errors have not even been detected because there were far too many
 * try/catch statements within JSP templates.
 *
 * See example: https://stackoverflow.com/questions/15108267/how-to-get-an-order-map-wih-aliastoentitymapresulttransformer
 */
public class AliasToCaseInsensitiveEntityMapResultTransformer extends AliasedTupleSubsetResultTransformer {

public static final AliasToCaseInsensitiveEntityMapResultTransformer INSTANCE = new AliasToCaseInsensitiveEntityMapResultTransformer();

    /**
     * Disallow instantiation of AliasToEntityOrderedMapResultTransformer .
     */
    private AliasToCaseInsensitiveEntityMapResultTransformer() {
    }

    @Override
    public Object transformTuple(Object[] tuple, String[] aliases) {
        /* please note here LinkedHashMap is used so hopefully u ll get ordered key */
        Map result = new CaseInsensitiveMap(tuple.length);
        for (int i = 0; i < tuple.length; i++) {
            String alias = aliases[i];
            if (alias != null) {
                result.put(alias, tuple[i]);
            }
        }
        return result;
    }

    @Override
    public boolean isTransformedValueATupleElement(String[] aliases, int tupleLength) {
        return false;
    }

    /**
    * Serialization hook for ensuring singleton uniqueing.
    *
    * @return The singleton instance : {@link #INSTANCE}
    */
    private Object readResolve() {
        return INSTANCE;
    }
}
