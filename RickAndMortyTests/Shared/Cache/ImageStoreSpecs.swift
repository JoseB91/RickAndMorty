//
//  ImageStoreSpecs.swift
//  RickAndMortyTests
//
//  Created by José Briones on 8/7/25.
//

protocol ImageStoreSpecs {
    func retrieveImageData_deliversNotFoundWhenEmpty() async throws
    func retrieveImageData_deliversNotFoundWhenStoredDataURLDoesNotMatch() async throws
    func retrieveImageData_deliversFoundDataWhenThereIsAStoredImageDataMatchingURL() async throws
    func retrieveImageData_deliversLastInsertedValue() async throws
}

import Foundation
import Testing
import RickAndMorty

extension ImageStoreSpecs {
    
    func assertThatRetrieveImageDataDeliversNotFoundOnEmptyCache(
        on sut: ImageStore,
        imageDataURL: URL = anyURL(),
        sourceLocation: SourceLocation = #_sourceLocation
    ) async {
        // Act &  Assert
        await expect(sut, toCompleteRetrievalWith: notFound(), for: imageDataURL, sourceLocation: sourceLocation)
    }
    
    func assertThatRetrieveImageDataDeliversNotFoundWhenStoredDataURLDoesNotMatch(
        on sut: ImageStore,
        imageDataURL: URL = anyURL(),
        sourceLocation: SourceLocation = #_sourceLocation
    ) async {
        // Arrange
        let nonMatchingURL = URL(string: "http://a-non-matching-url.com")!
        
        // Act
        await insert(anyData(), for: imageDataURL, into: sut, sourceLocation: sourceLocation)
        
        // Act &  Assert
        await expect(sut, toCompleteRetrievalWith: notFound(), for: nonMatchingURL, sourceLocation: sourceLocation)
    }
    
    func assertThatRetrieveImageDataDeliversFoundDataWhenThereIsAStoredImageDataMatchingURL(
        on sut: ImageStore,
        imageDataURL: URL = anyURL(),
        sourceLocation: SourceLocation = #_sourceLocation
    ) async {
        // Arrange
        let storedData = mockData()
        
        // Act
        await insert(storedData, for: imageDataURL, into: sut, sourceLocation: sourceLocation)
        
        // Act &  Assert
        await expect(sut, toCompleteRetrievalWith: found(storedData), for: imageDataURL, sourceLocation: sourceLocation)
    }
    
    func assertThatRetrieveImageDataDeliversLastInsertedValueForURL(
        on sut: ImageStore,
        imageDataURL: URL = anyURL(),
        sourceLocation: SourceLocation = #_sourceLocation
    ) async {
        // Arrange
        let firstStoredData = Data("first".utf8)
        let lastStoredData = mockData()
        
        // Act
        await insert(firstStoredData, for: imageDataURL, into: sut, sourceLocation: sourceLocation)
        await insert(lastStoredData, for: imageDataURL, into: sut, sourceLocation: sourceLocation)
        
        // Assert
        await expect(sut, toCompleteRetrievalWith: found(lastStoredData), for: imageDataURL, sourceLocation: sourceLocation)
    }
    
    func notFound() -> Result<Data?, Error> {
        .success(.none)
    }
    
    func found(_ data: Data) -> Result<Data?, Error> {
        .success(data)
    }
        
    func mockData() -> Data {
        Data(base64Encoded: "iVBORw0KGgoAAAANSUhEUgAAAGQAAABkCAYAAABw4pVUAAAACXBIWXMAAA7EAAAOxAGVKw4bAAAgAElEQVR42u2deZwU5Z3/309V9T33DAMMOMihgBpRwSMRo4lHiK5G1B8x2biIxFUkHok/XfPbEF8aN5cxGl3cGH8ar427rmdYQxSMBxrx5hYEBpjhnBnmnj6rnmf/eJ6u7p4LUE6z9Xr19HR3dXXV91Pf+3iEUor/3Q6ezTlUTlQIYQFhYIh5VAElQDTvOlwgDnQAzcB280gqpeQhcZ0HI4cY4lcBk4CTgeOAccBwA8CebHFgM7AaWAK8A7wPNB+MIB00gAghggaA84FzgGOA4D76uTSwAngZmAe8r5RK/y8gGojjgMuAS4DagfYNBWFQBQwbCoMroKoCioogaGCTEuIJaGuDHTtheyNsa4L2TtjFZdYDTwOPK6WW/M0BIoQIAxcC1wKnAFbPfQIOjBsDXzoBJn4BJoyDkcOgpBhsYQis+ju+PqKU0NEB9fXw4VJYthz+ugI+qgPZ93clsBi4D3heKZX8XANigLgCuBEY1fPzkiL42unwd1+Br34RBlcaEu3yuJCMQ9sO/Whv0o9kB7R1waod8EkTfNIM9c2QSO3W6dYBdwEP709g9gsgRkl/G7itJxCWBWedCv9wMZx3OsRCu3dMJWHnVtjZAM2boasFpKe5Zls7vF0H726CtdvB9T7T6W8E5gB/2B9GwD4HRAhxAjDXiCZ/K4rC5f8HZn8HRg/vX/z03Fq3QeMG2FkPbgY8qcVXPAmvroQFq2DN9kKdIQREQzC0CoZUQVkxOA5kXGjtgK1N+pHODPjTi4HZSqkPD0lAhBBRwxE35Ps7xTG45h/g+ulQVbJ7x3LT0LQBdqyHVFzrBmWAaGiCZ96Fl5dDIpPjutE1cMYJcNLR8IXRMGIoOEGtO4SlH5at97UcSGXgk02weBn85R14/T3oTvQ+FeAe4FalVPyQAcRwxePAUflKevol8OPvwZCK3QeicT00bQTPNSBIDcj6bfDo6/D6x5pLhNAgTP0ynPclGDUclABLGKIbELBz//vvZV8LQICwoSMOL/wFHnoaPlrVy0pbBVy2L7hlrwJidMXVwJ35DtxJE+DeW+GEsfqC+9QJniGO0Lpg56ZCILJcsW0nPPAyvLxUA+HYcMYEuHwKnHyUIbhjQLA/JSDmPLLW2psfws9+B4veKwAmDtwE/HZv6pa9BoixoP4NuDz7XiQEc66DG6aDIyDTBoHyfBTAS4CMa0IFyqG7BXashUxCgyCVfk6l4NFX4LFXIZHWQHxtElz1d3DE8DwCO3sREKvQjJ6/CG65E9bXF1z6I0a3xA8aQIQQVcAzwJez740dDY/9Co4fa8RPG8g0BKuNwZ/QACFBBMCphOaN0NlYyBEoeHc13P4kbGrSDPbFo+CGqTCuNk8P2PsYEMMx8TT8ZC7MfQK8nPX2BnCxUqr5gAMihKgFXjShDgAumgIP3AGlRmh53RoQEYTgIJBJyOzM2r0girV4SidyekJJSKbh7mfg31/TANVUwI0Xw+kTwDYEt/cXIB5YKRAGhAXvwxU/geY2nxQrgPOUUvUHDBAhxOHAK1nfwhLww9nwo1lgeZo4KgPpRr2/HQO7BNI7DGc44DqwcxuoHkq7bgt8/99gzWZNkGmTYdZ5EI0YIPY3IBKEOWdhac5dvwWmfg/WbixwJs9USm3c74AYzng1C4Zjw323w8yL9MlmmiFQBW4neB3G0hoEXqcGyS6BZAratueAwDzPXwy3PAjdSRhUArdeChOPzDNVDwQgRmQJkXtPCNjZCVNnwbtLC0D5yqflFOsz6Iz5WTCCAXj87hwYMgkyZcIehsWtCKi0fg4O0WB0NuV8AmGDsuDeZ+G6f9VgnDoWfj8bjh4BSRdSLqRdreitLAHzDIS9skkQabASuxe2qSyBFx+CySf6b40C5hsa7XsOMQ7f/KwCd2wNxsVn5cW2GzUXBAeD26H/tyKa6DKplbv0wJWQ8bSHnMrALXPhmddyxymNGRDSuWCgZUEkqC24khhUl0FNJdQO1n7IkSNgRA2EgzmwbcMl2HmcYffDIQosV+sKZVJfA3FI1ozvTsH5V8Ff3y9Q9F/fU+trjwAxfsZDWdPWEvBv/wKXX5i7Q2US3JZCEYXIcU7+lpH6ju9KwNW/gIXv7Z2bvCQG4w+Hk4+GLx0Lk8ZBLJInE6weYs42ABkC20kNngruPiAA7XE4Zzos/bjAJJ65J37KngJyjYlLAfDj6+CfrzbEjoMVNeatuSeCQzS3CNvsY3SEpyDt6dfJNFxxB7z2wb6LDxVHYfIEOPdLcNYpUF6S0xGWMB59VjcBlgQihthi9wERAjY3wemXwubt/tuzlVL373VATDjkLXRem2l/B4/83CghBZlGLaK8TvC6wAprM1c4YIW0LulsyfO8FbguzPwJLHhn/+UbomE462T4+6/D6ScYUWYcPwSElPk/rI2DXSn1noAAvP8+nH21TpYBSeDU3Q2z7BYgRm+8l41NHXE4vPUUlJi7SCbBawWnQpuvXgfYpfoEZbJQVEmTP3UlXH8nPLXwwGXnRg+H706FS6cYc1pAWEFGgGe4xwmCHdwzQGQHPPJnuOZ2P9SyCjhxd/TJ7lpZt2XBcGz47U+gOGLUhtJeNxjLygYR0orc6yoEw7UgbWT4nY8fWDAA1m+GH94Hk74N9/7Bv6P961ISUklIdoG3Bxl3JeHyqXDp+f5bRwE/2SscYkTVO9kQ+nenwb3/XHhHuI36AkQI7CJwWwsh95QGQyl9sc+/ClffoXXIwbRVlcFPr4FLzvatdRQgVE7PhGNgBYx66YdD3J3glENbAiZdCA1b/dD9ybsSXQMCYqyqt7LJpbISWPJHGFSW8zFEEDzjiVvRXPjaMlZNOqnvsuzVrd4AU2b1mWs4aLajRsG/XAunHm+cVZ9YxliJQijWGxBMxlJ2gl2hP//Tm3DRVb7ZvtjoE/lpRda38zN9s/9eJ5WU0rpCdhsZGTA7ODnLJNMEmR0g2iGUBkvpKO13bzu4wQBYVQcX/QCu/Tm0dRo2MQkxpbQI62opCC5qXdqlaSIiubfPPQ2mTvFfnmJouuccYsLpK7PeeHEMVvw3VBiTkSTQDaJUM6NKgAhrU1J25SlxG7yA/s6Nd8Hvn+OQ2oZWwd03wVcm5gARmMyjgOJKcEI5Za4y2sK0YrnQy6YdMOFcX0fVAUf3VzgxEIdcQV5BwrSvQ0WxuVtULiSi4uhyNksnmXwwLJBB/RDAqx/Ao89zyG3bmuHbP4Tbf6dz8EIZ8aNAutC+A1Ld5pJDBohQoSgbMRi+N70gtHLFHnFIT+4QAl79PRw/Ps8m7wayRQEVQKsGRgS0CPMkeBl9AYk0fPE7sGkrh/T2pWPht/8PKkvzbkyl1WlRJURLetIx939rF4w9C9o6BuaS/jjkwnzuOHwYHD/OmILZMDk9lFlQe7fKBdUBogPslLZO7nz00AcD4K/L4Lzr9bWEbIg4GgwloaMR4u39f7e8CK65rIBLLtwTkXVt/ospp2oFJiWIlNEZgdwRVNoo9najWzwdufWCsHEHzP0Dn5utYQdc+H/h3VU6FpetflES2rdDsrP/787+jg6K9kXjfgExtbYFNVSnTjBE9vSPWwl95ysTMscFEnkBRgvcoA5L3DZ3l/VOh9zW2ApTb4Z5b+YcSGVidc0NkOmnznFQKXzzgpzFZWi9Sw65LP99IWDCmLwkkpGbImWsJ5XzSZQNMgJuQJ/gR2th3l/4XG6pDMz6Bfzprz1AcXXpkuynWvIfv1lA+8sGBMS0BFyS/15RBIZU6h/wAUHnDFTWPhfgRky42gMno6Omv3io36Lmz8WWceHau+CV90x1jKev301C84a+vzPxaDhmrP/yEkPzfjlkEj1aAoZUGrvbM48eylwJ8GytwK0EWGmQAlZshJff5HO/ZVz43q9hyWpDD8MtnTuhq7kvs7YgxlVraN4vIOf3iu+U6sCaMHdARhYG0SRgZ3QBAIBnIqW/fbp3rGrGjBn8+Mc/5rrrrhsoXMP48eMZOXLkIQNKIgVX/lIr/GyRBhIa12nTv+c29awCk/j8gQA5p6/8gedpgodNVWHaEFoYvWKZ11Lo0PXOLnjupR6y0bKYM2cOt912G9OmTev34mbOnMmKFStYtGgRjnPItEDS2glX3aXDQllQMmloquu975gRMG503zTPU96imrzaKj/0YQ7uejo3HbZ1HtyTOj5lmQhuGkgadn16ga5GLwA2GqWmpkaHvdev7/fCjjzySCzLYvPmzXied0iJr7Vb4J8fyulWJLRuyXny+WLr7Mn+y2MM7XtxyCTj3jFcWH68sMuUdGYMbWwBQUtXmltCK7O4iXKG0YA9+afeJzt8+HBCIW2Er127tt+L+tWvfsXZZ5/NN77xDQ6plu1gCcSqmf8e/OerOS6RErZ/0nv300/KfTNfj+TLhJOz/5zhhHnNTbBZKV2Zp7TY8qSuhwrYOhziebo8JxrUQAEsr4dV63qfwBFHHOH/3x+HBINBfvrTnxKJRHjllVd4+OGHfb0ybdo0ZsyYwahRo0gkEnz44Yc88cQTTJ48mbfeeouFCxf6x7j00kuZMmUKFRUVxONxVq9ezZtvvklTUxMffvjhvuE86cGYr8OKJ7nz6TQTR0PtIA1I23ao7oRIcW73E4/VyT7TTHQy8KeegPhOyrGBMPVuis14NLZCJqV5KeOadCba6fOkBiILhlTwwpt9m7qjR+eE5rp16/q8pqqqKmbMmIFlWSxfvhyAQCDAE0880UvvHHvssUyfPh0hBNdffz0LFy5k+PDhPP/880ycOLHP47uuy4gRI9i6dR/EcZQHwWKo/TKJDQuZ8zg8dL0xhiTsWAeHH5/bfXAl1NZAXUMh7S1zB1roPnAtu5wwo4wZEE/pjlaZgY7OXHuYhZaVATsHRsKD+f2YumPGjNFmYibDpk2b+txn5MiRWJZVwEU/+9nPfDAWLVrELbfcwgMPPEAmk0GYc1y3bh2hUIh58+YxceJEpJQsXLiQBx54gO3bc+UfnZ2d7NixY9+ILNOFKirGIMpGsWwj/OfruUqbnfW638XXI8DRR/ovxxkMfA4Jo5vyCQFHOiHGCYFlCL2mHsaNhLZ22NkCleWaK6QCx3BOVxJ2JmBVP+ohK7JaWlpobW0dcJ8skWtra7n2Wh3ymTdvHlOnTvXFTTwe5/vf/76vk6644gqOO07faDfddBO//vWvAbj77rtZvnw5gUCADRs27AdDQUHtqdC5ld/+OckZR0NlkZZojRugZmxut/FjYN4rWsUaDOJZpT4E02BTZdlUWg5VCIabDMvilUakVEI4BM079Q0RdCCRhPYuKArDB6v6brAUQvgia+PGjWQymQG5KJ1OU19fz5QpUwiaJvS77767gJgdHTqOnUqlaGho8Llo69at3Hffff5+a9asobGxcZfW3Wfe8ktSnDCi5kS6knD//JyCb6wrzJOMPCxnhBoMyAcEgBrLwRGCiOVwvAHkrysg3q1/r7QEIhFoNdWJ7e265DPgwFvL+z7XcDjM8OHDd0mULCBNTU20t7czdOhQ/7OmpqaCfU85Rcc/GxoaSKVSjBgxQieUtm0rALyyspLKyspdWnefebOcAi4RlWMQkSr+vARWb9GAdLdBPNe+wGHVBUcoAMQvDB5k2SilKLcDnGAQ/7ihsGuotESLq2TSWF0BfaR3VvR9rsOGDfNN3g0bNhAKhQoeWQcwy0X19fW4rsuWLVv8Y1x55ZU4joPjOFx99dWcddZZ/vGUUjQ36zjFuHHjfGCDwSC//OUvCYfDAxoTe2VzQr1af0XNJKQU/G5BLqTSlKc+hwwptGnyAfFzXVXCRgHldoDhRmy5Hrz0HnTlOThFMY161pnuTMD6hv6dvex244030tjYWPCYNWsWgUDAv8s/+UQb7n/84x9pb9dZn+uuu46NGzeyceNG7r//fmzbLtj36aefBiAWi/Huu+/y4osvsnLlSq64Ipctraur24eARHrP7ygeAsU1vLMOPt5sxFZ9TmwVxwr2LskHxG/QLDJiqsIOooTiy+b1i+/Ati3QaRIwsTxAlIKlayHVTzFZvskbDocpKSkpeDQ0NFBeXu6LlizhGhsbmT59Op3mR4cNG8awYcN8nZAvAu+9914WLFgAQHl5Oeeeey6jR4+moaHBRBzkvuWQYKxv1VJ9LEoJ/t24Ax1NuXxJUUj3t+Rj4OR5i9ruN2KqyglhAadZFk9JWL4RVm/SrQGlZZrdAgF9wK1bYeUA17p06VJuvvnmfj9fvHgxSiluueUWAF56KRcIe+GFFxg7diznnnsulZWVrFmzhsrKSh566CEtTj/WpebJZJJzzz2Xiy66iFNOOYVkMsmLL76I4zicdNJJeJ5XYALvfUCK+wYkNggVq+avn+xgawsMKoLW7VA9AuyA8ee8HAZCKYUQ4nvogSvcECnjF7FBADzX3oCnJA9IyRvSZeopcPMlmuUsG4YN089btsBjr8N9T+9tw0Xwox/9iGXLljF//nw8z2PSpEk89dRT1NbW0tzczMiRI+nq6jrwoZPDz4SqsQilU6vCZPSU50FHA2rTa1w8CS4/FQ6fAGNPgZZOOGwyGBtktlLq/iyH+MImkycHhzgRtmbinGfZLJIu8z+AGWfqriElYUsDDKvVNvbmpr1/jTfddBO33XYbQgg6OztJJBIMGjQIIYTPUflgjB8/3jcQsg6m67o0NDT4ZvI+s3oj5f02cVnFw/CcKAtWxvn7k/V4EESuEyAbSMjXIX5VdnfeHoOdMBaC0QgmCJtkBp58VReDyYwOL2frk5ra9/5FLl++nJ07dbtucXEx1dXVCCHYsmULM2bM8GNdWd300UcfsWzZMpYtW8aSJUtYsmQJK1asYNu2bdx///1EIpF9BQciUj7g51bZSDoS8G6dnlSE0m17ea5VPF+H+LdPSx4gQwMRlidaEQgutQMsdT2eew8uOUm3kmFDZ7tW8HntwXttmz9/PmPGjGHy5MnU1tbieR5r165l8eLFJBKF9aiHHXaYb1pno8TZ0Eo0GmXWrFkkk0l+8IMf7P0TDZVos9dzddOLkqgeRQhWcS2yeSWvfwITD9MzWzrjBeVUHfmA+MnGRulmO9CIWjbldpAumWE8FhMth/czLg+9CrdcoFOWrdvg8HHaW98XW3t7Oy+++OIu98sPu8yePZuXXnqJiooKJk6cyN13300kEuFb3/oWN954494P60erkUk9FUfJwtogIT0UUit9J8JH9QkSKehqgx5hteZ8QHzzY6v0kPhtgQwPRlmT7MACrrCCfCRdXloO007V096atuhYVsY9sDo137T+4IMPqKuro66ujvfff5+ZM2dy4oknEo1GKS8v5/TTTwfgo48+wnEczjzzTGzb5rXXXmPVqlU+x11wwQV+dPi5557rNyhKtHrgGYJKId0MVriaZNcmlm+BU9uhobFgr+09AYkD0Sbp0aUkxcb/GBaIsi7ZgYVglIDz7CB/9NL8/Dl4rBZGfwFamnIJrAMNSDqdZuPGjf77Rx11FEcffbQP1PHHH8+zzz4LwCuvvMJpp53mx8uuueYa1qxZw5w5c7j55psLdM4dd9zBlVdeyZNPPtn7x2M1hTEty0ZIieqRhxDhCujaxJLNEO+ADZsL9EcBIEn0KNUjEyjqvQxHm5LukGVT7URocZMIBFfYIRbJDKu3KR57BS5NwPCxB775Jj8acPvttxONRhk8eDCTJ08mGo2SyWS49dZbGTfOzzJw5pln4nkeyWSSRCLBE088wdy5c7nqqqsA2LFjB83NzYwfP55YLMbvf/97li5d6nORnykMl/qTDATSN3uFslGera2fTBorWIYHLN+qh+uszvlumw0GpmdTN5Cszn66zCscSlgbiiEAG4tiLK5ztGP/u1dhYyNsWt3v1KX9ziHBYJCrrrqKyy67jHPOOYdoNEpjYyMXX3wxixYtKgDuwQcfpKqqiqKiIkaPHs0ZZ5zhg3HPPfdQW1vLMcccw6WXXopSilAoxMyZMwt/uHQEBMMIJ1hYXZ3PGU4AJxDCChYDgsZO2NIKK3Kp3dXZJp78EOUS4AKADzMpvpU3+7DCCVFih0hKDwF81Qrwhh3kVTfNbc/Bg9/NJaoOxOY4jh8Hq6+vZ+nSpWQyGZqbm3n77bd55pln/PBLFrgdO3Zwww03EI9ri7+1tZXZs2f7KYJ/+qd/Ip1O+3GylpYWKisrC3SVDmmM1YFElLas3NzQFpWNyCsQlkUgFCVlh5BekvfWwqYtBbTvlVP3m5Pfdnu3OI0Ixfgk0YEQAgHc7ERZKV3Wbpfc9zIEDyAgtbW1vsn72GOPMWfOnH49/yxBly1b5oOR/Wz8+PEArFy50gcDoKSkhFgs5gNeEC4pHgKeh3TT4Lm+laWy4V0UwrFy6sWJIL0kz7zue+gFtM+vOnk/67Evd9O09WiDqwqEKbIDmAkVlCK4I1CEDTz7LjR1HDhAsuH2XYXYA4EAtbW1fe6nlPKd0BNOOIHy8nLf47/11lsJh8NIKQuVetU4U5KT6l+JSolKpZCeLs2xTN5kZa7UNG1oXwiIUqoRPfOJJIpFmd4t1YeHY9jaL0UIwXFWgOsDMRSfeRTrfgGkurqasrKyfvf7j//4D+0QDx3K22+/zdy5c3njjTe44YYb/HRAMBjUDqewoHKsjrb2zBxaVi994rlpY3X1qm9fYWjfS2SBnoV+AsB/p7o5P1hUGLC3g5Q7Idq9NBYCIeA7gRDrlMsf3dQBAyQrhlzXZcOGDbvlq/QFyG9+8xu++tWv8rWvfY2xY8cyduxYP3T/wAMPsGTJEr75zW/S0dHBR3Ut4BSZWlGhrZpAyOgMiVAeys1AMnenum6aXMN1Ac3pD5B5wC0Af0p3k0YR7GE/HRYuojveBghsoTsf54SKaFSKxd6BmWefSCR44403iMfjA1aVhMNh3njjDV9P9NxSqRQXXHAB06dPZ+rUqZSWlrJq1SoeffRR3nrrLSZMmEAikdBm74gpJhCl73oRCKIEuhzIBESEbevZVSnPdxA9txeN5hUwWH4YwZTGr8VUwL9QUsOUHokXBbS6abamu828KoXAJqFgZrKVVfJz1p3T1xapgnHTDHdIsBxEIIAynFEQfpceIpFASY+gVKQ2/UnPp9JbPXBE/soMVg/FlkavEqAtlmTfmrrMCVLmBI02sRBAEYL/Hy5nrOV8/gGpnpQXps0bPddn2AR/0pryUvlgADzdc5mMvo70OKYNZF66i+39tAINDUaICAfLQGIDZULwSKSSo63A55g7qqF0ZG7QPFZBUqOPyLtfyinTBTkKaWjNgICY9TMWZ+2xB5Nt/WUAGBaK4AgLO3ujICgTFo9FK/miHfwcoiGg5hRyzZRm+rM/07aPb2SH0wMq2ZL/0eK+1irpj9f8SrPfJtro7ieS6QiLYcEolhC+KazFl8WD0Uq+EYh8vvCoGAOlpsHMMlN1jARR6VQvUJSUqLTrgynjO/qk8e4A8jy6uZ1mJfldsv/sU9CyGBKMYBswBBYInbG/M1zOTcES7M8DGFYARp6hY0TGmCEQ1AW70nBBKolKpVDpDDKVRqUyPjepdBcq7dOxztB49wAxEwbuyr7+dbyV9gHkZFDYVAcj2MLCEtn5MwLPklwVLOLhSCVVwjq0ARlxGoSKjL8RMNM1HV064mZ0DEtK07fh5eZvKIl0XeisJy8/eNenmXXyMHoxExqVx13xlgHPNyAsqgJhAkZ8IRQpO4NnKU61w8yLVXNG4BDVKyXDYehxuSSULSBsxLHtgGP6wF2TqXNdHU7JpFCei7As6PKTWxsNbdkjQAyCfpTu3mQb67yBfQxHCCoCISKWja20OexaHkLAIOHwm6ISbo8VUSzEoQOGHdKNONnpa8osQBII6FXKsqGSQEBXDdpWjnucoA7Ld2+BXMB2zkBLKO1Kjvwha3EllOL7XY0DziveShcdpChxAhQ5AQLKxrMkhmewhOAboTDzY9Wc54Q5+GERMPIscKL6rs+KJTuQU+zhoF4mLn9VgOzYbTOTXLX4c2MXG5ryqQAxSZPZmJqhlzPxfp1FHYexaCWJhyRk2ZSJMMpAaFlgKYFQMFg43BOu5N+jlXzhYPZZaiZCpAY6O3QNbWeHWT3GKgTNshHBEISjiHAIEQpihQKIUAC6NkKmE0PD2bua4btLTWtmBN6bfX1zdxMb+hFdFYQRCNrRgcYIDkIIrfuMFWYZzx6hmGiH+K9oFfeGyw4+D79sJNRO1lXlRdFcJHdX/lV20LxlIbwkqtEfCn/v7oyK3V3TZw561CntSjKjczupHsJLoVO8VUToJINEYSEI4SAtRdTS4guUiUznBhae5YR5JlLFv4bKmGQFOOD2WLgShp2uc+GpNHR26U6lcHG/ado+b+b6t7PjTFfl6+MBheSnHaR8VbiEe4qqs0FMfwYNKJpJYCEoU2FSJtxsIdgqOnGwKPHCpKXEVQqppP6uUnjmebVM85yb4GUvRev+bo0OlcK4i/R0z5Rx9iIR3ULrmXvIsfXVSs/vfRamOE4HFyXsWIba8g7si0HKeaD4o8YFcE/RIP4xXIpS0EgcB5sSgigUO0lSqSJkkLSIBB6SNB42FpUyiqcUnpJkpCKD1IAo8JTOTXtKEleSd2SaV7w070iXNvYxOMFiOOoSCJdonvckdHVCKAKl1WY+lZebDNAfIO0NqPV/znru+2bUuAGkYBi/AzxVMpQpgRhpPLbQhUBQTZQANlIpukjTIpKm8E6LsSoZM9yhcJVHl5MCaeG4Nq5UeEhcKXGVRKLwlCKpJB+rDB9Ij6XKY72SdO9NMAJFUHsOxCohHDaVggqRyaBUCMrKdRHzrgDpbkJ98kJWVD3CvhzGb0ApWK4iKgTPFtcwOaC5YRtdxAhQQojtdJPBywYPfNFVKWN4Rlx1WilcIbE9G8ez8JTCzXKP4RRXKVwlcdGPjFIkUGxWHnVKsVkptqFoUhxa8JsAAAWvSURBVNCGIkFeOf9ucUYp1tgLwIkiE3EIBBGRiD7jQLFuHSsr2zWHJNvg42fBjcP+WK4iD5Qq4HXM+PEiIXi6uIZTAxE8JCk8Gon7Jm/+X4BiFSIgHTqtJGk8LCUIuQEjtpSvWzQgChcDiPLIoMgoqZ+RZIC0AlcpMig9cwVFXEEcRdwIcYlCKthpTtz3zIpqoOY0rFAMKxzGc11UvBtRVIIqGqTX00gmTGPlABySbEOtfhbSXVklfvqnWSTsUxk05oe+ng1AdinFRZ1bWZjuxkbgIn0weqYGADpFip12N2mzwlbUCxZO1dylISN67ZY3JBSBDm5GgWKgzDyvAxbkgSGqxuEceR5EYshUEi+T9j1tFSrTw8CSCYiEBz6dRAvq42eyYNQZzvhUK7Z9agvTrLF0dhaUuFJ8s3M7jyQ7iOIY35xepnEvaSFthNq3PnsH8IKCd7OWoLARNV+EEZOxUQjHRoQCqO4uPV8pYjijs1Prk9AAgHRsgVX/BZnuLBhnf5aV2j6TN6aUqhNCfAWzbF4axXXdTazx0vwwVkZLntjqU48qm4gXYF+VBXtoEN5WimxWwgqXI2q+iLSiONLDFQKhBCLgoMLFSLtUV7CFQrr53hL911xtXw4b/mIKGw6CZfN66JSChSVPckL8sqiMCtvrpUMAgsoh6gW0CDY6ImtRuSikHEiHaP3hIkkbHZLJ0yFpFMuVYoFS7PRP0sIadBSBwRNQlkWmuxth2TjRKBnLQkSrkcFSzRWOoxcUyV9UMdsqpjydA1m/ABr9SQkHz8KSPayvueQtvRoVglmRKN8OR3DM0gIOFjEZxFG2trSk2quArFSKl1BsyrsuK1JFYNiJyGiFHrhmehTdZBJFAEoOAyesO6CCAYhGC8HIAqI86NgMq/8bEj7tH+FgW3q1h5/Sa3HiWstiVjTKtEApMRxd6Wj8kL0BSFLBe1KyQEk25XGicKI41ccQLBsBwkIKCymE3kPYeCU1eKFKwxV2TnmbYreCh5eBja/B5sVZEXVwL07cR5ilYPlugGGWzeXBYi4OxRgsbA3KpwTEQ7FOeSxSHm9KSX6SWdghgpVHIMtHYQtH5/yFLllSlk2yZCheoFJPr1S5zJ7/XFpmVnHJTrNcBetegqQ/xejQWL67DxHWa4F70FPJT7RDnBUIc4oV4gjbQUABAPmAZAHbKl1WKY8lyuM95dGoCk0GEYjilI0iXFKLsB3SAqSwcBAoO4BXOpxMyXCU7eiwSNanaO/QoioYMFM9zdqqLXVaV7RvzP7EobnAfR/cMpce48sLgqsIai2bWmFTJiyyRma3knQoyVYl2awkXf14N3a0ikDJcKzYIPQiWAIbnclLRytxSw7DK67WkVqfI7LPQEuLzv6FzQCZ5jWw4VVoK5iNstjoig/3Kb32x6BJo1u+bThm1Gc/oIUdLMGODsKJVmM7QZSlxZISAdyiatziobjFQ7Wyzp+Rrvp4VgpSnbD1Q2h4G+IF3Zh1wK3AH/amrjiggOQBE0YvZnLjngEjEE4YJ1iCHSrBCZViWQGkZSNDRchoJTJWhRurRkYqcss5Z/lJqd6AgF7KoGkVbFsCO9dos7YQiLuAhwfKgR/SgPQA5kL0kg2n9B8xENjhKuyqcYiyWlSoGBWIIIMxVKgYGSzKVXwUhANUj9iA0Poi2Q5t9dC6Hpo/0SasKiiVlUY03Qc8vz+BOKCA9ADnOPQqAZfQY+58wWaHIDoIiqohVg3hMggWQSCk1xiybLM8QRq8FKTjkGqHRAt0N0LXDkh19BPAoR5dZP54X+Wdf1OA5AGTHSh8Pnr89jHkjY3ay1vahDpeRvdnvN+zCv1vHpA+jIAqA9DJ6Lm249DTO6N7eLg4ug98Nbrb9R10T1/z/lDSnwtABgApDFQDNQawEgOQk+cnxE2AtxnYCjQCyYOR+Ic0IH8r2/8A/SQ88zLm08AAAAAASUVORK5CYII=")!
    }
        
        func expect(_ sut: ImageStore, toCompleteRetrievalWith expectedResult: Result<Data?, Error>, for url: URL, sourceLocation: SourceLocation = #_sourceLocation) async {
            // Act
            let receivedResult: Result<Data?, Error>
            
            do {
                let retrievedData = try await sut.retrieve(dataFor: url,)
                receivedResult = .success(retrievedData)
            } catch {
                receivedResult = .failure(error)
            }

            switch (receivedResult, expectedResult) {
            case let (.success( receivedData), .success(expectedData)):
                // Assert
                #expect(receivedData == expectedData, sourceLocation: sourceLocation)

            default:
                // Assert
                Issue.record("Expected \(expectedResult), got \(receivedResult) instead", sourceLocation: sourceLocation)
            }
        }

    func insert(_ data: Data, for url: URL, into sut: ImageStore, sourceLocation: SourceLocation = #_sourceLocation) async {
            do {
                // Act
                try await sut.insert(data, for: url)
            } catch {
                // Assert
                Issue.record("Failed to insert image data: \(data) - error: \(error)", sourceLocation: sourceLocation)
            }
        }
    }

