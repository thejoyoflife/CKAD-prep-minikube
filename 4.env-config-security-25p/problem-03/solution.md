- k get crd operators.stable.example.com -o yaml
- Search the doc with `kind: CustomResourceDefinition`
- The four precious properties of every k8s object 
    - apiVersion: stable.example.com/v1  - `<group>.<one_of_the_versions>` - `k get crd operators.stable.example.com -o yaml | grep 'group'`
    - kind: CustomResourceDefinition - `k get crd operators.stable.example.com -o yaml | grep 'kind' ` - Operator
    - metadata:  `k get crd operators.stable.example.com -o yaml | grep 'schema' -A20 ` - we need to know the schema
        ```
        spec:
            properties:
              age:
                type: integer
              email:
                type: string
              name:
                type: string
            type: object
        ```
    - name: mycrdobject
- k apply -f crdobject.yml 
- k get op `check if the object is created`
- k describe op mycrdobject `See the spec and other details`